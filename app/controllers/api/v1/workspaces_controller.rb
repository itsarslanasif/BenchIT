class Api::V1::WorkspacesController < Api::ApiController
  before_action :find_workspace, only: %i[invite switch_workspace]
  before_action :find_profile, only: %i[switch_workspace]
  before_action :check_profile, only: %i[invite]
  skip_before_action :set_workspace_in_session, only: %i[index create switch_workspace]
  skip_before_action :set_profile, only: %i[index create switch_workspace]

  def index
    @workspaces = current_user.workspaces
  end

  def create
    switch_database
    @workspace = Workspace.new(workspace_params)

    ActiveRecord::Base.transaction do
      @workspace.save!
      Current.workspace = @workspace
      create_profile
    end

    setup_database(Current.user, @profile, @workspace, @workspace.company_name.downcase)

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
    Current.profile = @profile
  end

  private

  def workspace_params
    params.permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
  end

  def find_workspace
    @workspace = Workspace.find(params[:id])
    Current.workspace = @workspace
    establish_connection_to_workspace_db(@workspace.company_name.downcase)
  end

  def find_profile
    @profile = current_user.profiles.find_by!(workspace_id: @workspace)

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity if @profile.nil?
  end

  def check_profile
    @user = User.find_by(email: params[:email])
    return if @user.blank?
    return if @user.profiles.find_by(workspace_id: @workspace).blank?

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity
  end

  def create_profile
    user = Current.user
    @profile = Profile.create!(username: user.name, workspace_id: @workspace.id, role: 0, user_id: user.id)
    Current.profile = @profile
  end
end
