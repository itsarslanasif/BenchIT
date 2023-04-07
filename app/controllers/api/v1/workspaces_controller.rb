class Api::V1::WorkspacesController < Api::ApiController
  skip_before_action :set_workspace_in_session, :set_profile, only: %i[index create switch_workspace]
  before_action :find_workspace, only: %i[switch_workspace]
  before_action :find_profile, only: %i[switch_workspace]

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
      WorkspaceMailer.send_workspace_create_mail(@workspace, @profile, current_user).deliver_now
    end

    setup_database(Current.user, @profile, @workspace, @workspace.company_name.downcase)
    switch_workspace

    render json: { workspace: @workspace, success: true, message: t('.success') }, status: :ok
  end

  def switch_workspace
    session[:current_workspace_id] = @workspace.id
    Current.profile = @profile
  end

  private

  def workspace_params
    params.require(:workspace).permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
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

  def create_profile
    user = Current.user
    @profile = @workspace.profiles.create!(username: user.name, role: 0, user_id: user.id)
    Current.profile = @profile
  end
end
