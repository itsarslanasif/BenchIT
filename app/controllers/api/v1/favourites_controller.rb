class Api::V1::FavouritesController < Api::ApiController
  before_action :set_favourite, only: %i[destroy]

  def create
    @favourite = Favourite.find_or_create_by(favourites_params)
    if @favourite.id
      render json: { message: t('.success'), favourite: @favourite }, status: :ok
    else
      render json: { errors: @favourite.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @favourite.destroy
      render json: { message: t('.success') }, status: :ok
    else
      render json: { errors: @favourite.errors }, status: :unprocessable_entity
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
    render json: { error: t('.not_found') }, status: :not_found if @favourite.nil?
  end
end
