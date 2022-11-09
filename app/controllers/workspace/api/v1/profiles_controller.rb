class Workspace::Api::V1::ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show update destroy]
  before_action :set_identity, only: %i[index create]
  def create
    @profile = @identity.profiles.create(profile_params)
    render json: @profile.errors if @profile.errors.any?
  end

  def update
    @profile.update(profile_params)
    render json: @profile.errors if @profile.errors.any?
  end

  def index
    @profiles = @identity.profiles
  end

  def show; end

  def destroy
    if @profile.destroy
      render json: { status: :ok, messages: 'deleted successfully' }
    else
      render json: @profile.errors
    end
  end

  private

  def set_identity
    @identity = Identity.find_by(id: params[:identity_id])
  end

  def set_profile
    @profile = Profile.find_by(id: params[:id])
  end

  def profile_params
    params.require(:profile).permit(:username, :profile_image, :workspace_id, :description)
  end
end
