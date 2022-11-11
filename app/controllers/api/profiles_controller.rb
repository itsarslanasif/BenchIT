class Api::ProfilesController < ApplicationController
  before_action :set_workspace, only: %i[index ]
  before_action :set_user, only: %i[index ]

  def index
    @profiles = @workspace.profiles
    render json:@profiles
  end


  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_workspace
    @workspace = Workspace.find_by(id: params[:workspace_id])
  end

  def set_profile
    @profile = Profile.find_by(id: params[:id])
  end

  def profile_params
    params.require(:profile).permit(:username, :description)
  end


end
