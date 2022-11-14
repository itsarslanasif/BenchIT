class Api::ProfilesController < Api::ApiController
  before_action :set_workspace, only: %i[index ]

  def index
    @profiles = @workspace.profiles
  end

  private

  def set_workspace
    @workspace = Workspace.find_by(id: params[:workspace_id])
  end

end
