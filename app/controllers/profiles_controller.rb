class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show update destroy]
  before_action :set_identity, only: %i[index create]

  def index
    render json: @identity.profiles
  end

  def create
    @profile = @identity.profiles.new(profile_params)
    if @profile.save
      render json: @profile, status: :ok
    else
      render json: @profile.errors
    end
  end

  def show
    render json: @profile
  end

  def update
    if @profile.update(profile_params)
      render json: @profile, status: :ok
    else
      render json: @profile.errors
    end
  end

  def destroy
    if @profile.destroy
      render nothing: true, messages: :no_content
    else
      render json: @profile.errors
    end
  end

  private

  def set_identity
    @identity = Identity.find(params[:identity_id])
  end

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:username, :profile_image, :workspace_id, :description)
  end
end
