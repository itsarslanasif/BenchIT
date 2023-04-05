class Api::V1::WorkspacesController < Api::ApiController
  skip_before_action :set_workspace_in_session, :set_profile, only: %i[index create switch_workspace]
  before_action :find_workspace, only: %i[switch_workspace]
  before_action :find_profile, only: %i[switch_workspace]

  def index
    @workspaces = current_user.workspaces
  end

  def create
    @workspace = Workspace.new(workspace_params)

    ActiveRecord::Base.transaction do
      @workspace.save!
      Current.workspace = @workspace
      create_profile
      create_workspace_data
      switch_workspace
      WorkspaceMailer.send_workspace_create_mail(@workspace, @profile, current_user).deliver_now
    end

    render json: { workspace: @workspace, success: true, message: t('.success') }, status: :ok
  end

  def switch_workspace
    session[:current_workspace_id] = @workspace.id
  end

  private

  def workspace_params
    params.require(:workspace).permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
  end

  def find_workspace
    @workspace = Workspace.find(params[:id])
  end

  def find_profile
    @profile = current_user.profiles.find_by(workspace_id: @workspace)

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity if @profile.nil?
  end

  def create_profile
    user = Current.user
    @profile = @workspace.profiles.create!(username: user.name, role: 0, user_id: user.id)
    Current.profile = @profile
  end

  def create_workspace_data
    ActiveRecord::Base.transaction do
      new_channel = BenchChannel.create!(name: 'general', description: 'general')
      BenchConversation.create!(conversationable: new_channel)
      new_channel.channel_participants.create!(profile_id: @profile.id, role: :channel_manager)
    end
  end
end
