class Api::V1::WorkspacesController < Api::ApiController
  before_action :find_workspace, only: %i[invite switch_workspace]
  before_action :find_profile, only: %i[switch_workspace]
  before_action :check_profile, only: %i[invite]
  skip_before_action :set_workspace_in_session, only: %i[index switch_workspace]
  skip_before_action :set_profile, only: %i[index switch_workspace]
  after_action :change_database, only: :index

  def index
    switch_database
    @workspaces = current_user.workspaces
  end

  def create
    @workspace = Workspace.new(workspace_params)
    @workspace.save!
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
  end

  private

  def workspace_params
    params.require(:workspace).permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
  end

  def find_workspace
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      encoding: 'unicode',
      pool: ENV.fetch('RAILS_MAX_THREADS', 5),
      username: ENV.fetch('POSTGRES_USERNAME', 'postgres'),
      password: ENV.fetch('POSTGRES_PASSWORD', 'postgres'),
      host: ENV.fetch('POSTGRES_HOST', 'localhost'),
      database: Workspace.find(params[:id]).company_name.downcase
    )

    session[:current_workspace_id] = Workspace.first.id
    @workspace = Workspace.first
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

  def change_database
    establish_connection(Current.workspace.company_name.downcase)
  end
end
