class Api::V1::WorkspacesController < Api::ApiController
  before_action :find_workspace, only: %i[invite switch_workspace]
  before_action :find_profile, only: %i[switch_workspace]
  before_action :check_profile, only: %i[invite]
  skip_before_action :set_workspace_in_session, only: %i[index create switch_workspace]
  skip_before_action :set_profile, only: %i[index create switch_workspace]

  def index
    ActiveRecord::Base.establish_connection(:development)
    @workspaces = current_user.workspaces
  end

  def create
    @workspace = Workspace.new(workspace_params)

    ActiveRecord::Base.transaction do
      @workspace.save!
      create_profile
    end

    Current.workspace = @workspace
    Current.profile = @profile

    render json: { workspace: @workspace, success: true, message: t('.success') }, status: :ok
  end

  def invite
    @token = Token.new.generate
    create_invitable if @user.present?
    WorkspaceMailer.send_email(params[:email], @workspace, @token).deliver!
    render json: { success: true, message: t('.success',
                                             email: params[:email], company_name: @workspace.company_name) }, status: :ok
  end

  def create_invitable
    @invitable = Invitable.create(user_id: @user.id, workspace_id: @workspace.id, token: @token, token_type: 'workspace_invitation')

    return unless @invitable.errors.any?

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity
  end

  def switch_workspace
    session[:current_workspace_id] = @workspace.id
    Current.workspace = @workspace
  end

  private

  def workspace_params
    params.permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
  end

  def find_workspace
    switch_database
    establish_connection_to_workspace_db(Workspace.find(params[:id]).company_name.downcase)
    @workspace = Workspace.find(params[:id])
  end

  def find_profile
    @profile = current_user.profiles.find_by(workspace_id: @workspace)

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity if @profile.nil?
  end

  def check_profile
    @user = User.find_by(email: params[:email])
    return if @user.blank?
    return if @user.profiles.find_by(workspace_id: @workspace).blank?

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity
  end

  # def create_db
  #   create_database(@workspace.company_name)
  #   establish_connection_to_workspace_db(@workspace.company_name.downcase)
  #   ActiveRecord::MigrationContext.new('db/migrate/', ActiveRecord::SchemaMigration).migrate
  #   Workspace.create!(id: @workspace.id, **workspace_params)
  #   user = current_user.dup
  #   user.id = current_user.id
  #   user.save!
  # end

  def create_profile
    user = Current.user
    @profile = Current.user.profiles.create!(display_name: user.name, username: user.name, pronounce_name: user.name, workspace_id: @workspace.id, role: :workspace_owner)
    create_database(@workspace.company_name)
    establish_connection_to_workspace_db(@workspace.company_name.downcase)
    ActiveRecord::MigrationContext.new('db/migrate/', ActiveRecord::SchemaMigration).migrate
    new_user = user.dup
    new_user.id = user.id
    new_user.save!
    new_workspace = @workspace.dup
    new_workspace.id = @workspace.id
    new_workspace.save!
    new_profile = @profile.dup
    new_profile.id = @profile.id
    new_profile.save!
  end
end
