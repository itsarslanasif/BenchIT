class Api::V1::FavouritesController < Api::ApiController
  before_action :set_favourite, only: %i[destroy]
  before_action :initialize_favourite, only: %i[create]

  def create
    if @favourite.id
      render json: { success: true, message: t('.success'), favourite: @favourite }, status: :ok
    else
      render json: { success: false, message: t('.failure'), errors: @favourite.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @favourite.destroy!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  private

  def favourites_params
    params.require(:favourite).permit(:favourable_type, :favourable_id).tap do |param|
      param[:profile] = current_profile
    end
  end

  def set_favourite
    @favourite = Favourite.find(params[:id])
    authorize! :destroy, @favourite
  end

  def initialize_favourite
    @favourite = Favourite.find_or_create_by(favourites_params)
    authorize! :create, @favourite
  end
end
