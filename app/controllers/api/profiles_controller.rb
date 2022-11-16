class Api::ProfilesController < Api::ApiController
  before_action :set_workspace, only: %i[index create]

  def index
    @profiles = @workspace.profiles
  end

  def create
    if current_user
      @profile = current_user.profiles.new(profile_params) # assuming that the user is already logged in
      if @profile.save
        render json: "Profile Added to #{@workspace.company_name}"
      else
        render json: @profile.errors
      end
    else
      render json: {message: "user not logged in"} , status:401
    end
  end

  private

  def set_workspace
    @workspace = Workspace.find_by(id: params[:workspace_id])
  end

  def profile_params
    params.require(:profile).permit(:workspace_id, :username, :description)
  end

end
