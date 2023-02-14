class Api::V1::FavouritesController < Api::ApiController
  before_action :set_favourite, only: %i[destroy]

  def create
    @favourite = Favourite.find_or_create_by(favourites_params)
    if @favourite.id
      render json: { success: true, message: t('.create.success'), favourite: @favourite }, status: :ok
    else
      render json: { success: false, message: t('.create.failure'), errors: @favourite.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @favourite.destroy!
    render json: { success: true, message: t('.destroy.success') }, status: :ok
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
