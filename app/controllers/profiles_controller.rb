class ProfilesController < ApplicationController
  def create
    @profile = current_user.profiles.create(profile_params)
  end

  private
  def profile_params
    params.require(:profile).permit(:workspace_id, :username, :description)
  end
end
