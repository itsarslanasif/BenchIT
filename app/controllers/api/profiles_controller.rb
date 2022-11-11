class Api::ProfilesController < ApplicationController
  before_action :set_workspace, only: %i[index ]

  def index
    @profiles = @workspace.profiles
  end

  private

  def set_workspace
    @workspace = Workspace.find_by(id: params[:workspace_id])
  end

  def profile_params
    params.require(:profile).permit(:username, :description, :profile_image)
  end
end
