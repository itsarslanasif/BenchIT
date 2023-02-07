class Api::V1::DmListsController < Api::ApiController
  before_action :set_dm, only: %i[destroy]

  def index
    @profiles = Profile.where(id: @current_profile.dm_lists.pluck(:receiver_id))
  end

  def destroy
    if @dm.destroy
      render json: { message: t('.removed') }, status: :ok
    else
      render json: { error: t('.unable_to_remove'), errors: @dm.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_dm
    @dm = @current_profile.dm_lists.find_by(receiver_id: params[:id])
    render json: {message: t('.not_found') }, status: :not_found if @dm.nil?
  end
end
