class Api::V1::FavouritesController < Api::ApiController
  before_action :set_favourite, only: %i[destroy]

  def create
    @favourite = Favourite.find_or_create_by(favourites_params)
    if @favourite.id
      render json: { message: 'Channel successfully added to favourites', favourite: @favourite }, status: :ok
    else
      render json: { error_message: 'Channel not added to favourites', errors: @favourite.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @favourite.destroy
      render json: { message: 'Channel successfully removed from favourites' }, status: :ok
    else
      render json: { error_message: 'Channel not removed to favourites', errors: @favourite.errors }, status: :unprocessable_entity
    end
  end

  private

  def favourites_params
    params.require(:favourite).permit(:favourable_type, :favourable_id).tap do |param|
      param[:profile] = Current.profile
    end
  end

  def set_favourite
    @favourite = Favourite.find_by(id: params[:id])
    render json: { error_message: 'Channel could not be found in favourites' }, status: :not_found if @favourite.nil?
  end
end
