class Api::V1::FavouritesController < Api::ApiController
  before_action :set_favourite, only: %i[destroy]

  def create
    @favourite = Favourite.find_or_create_by(favourites_params)
    if @favourite.id
      render json: { success: true, message: I18n.t('api.v1.favourites.create.success') }, status: :ok
    else
      render json: { success: false, message: I18n.t('api.v1.favourites.create.failure') }, status: :unprocessable_entity
    end
  end

  def destroy
    @favourite.destroy!
    render json: { success: true, message: I18n.t('api.v1.favourites.destroy.success') }, status: :ok
  end

  private

  def favourites_params
    params.require(:favourite).permit(:favourable_type, :favourable_id).tap do |param|
      param[:profile] = current_profile
    end
  end

  def set_favourite
    @favourite = Favourite.find(params[:id])
  end
end
