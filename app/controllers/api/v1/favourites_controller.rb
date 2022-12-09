class Api::V1::FavouritesController < Api::ApiController
  before_action :set_favourite, only: %i[destroy]

  def create
    @favourite = Favourite.find_or_create_by(favourites_params)
    if @favourite.id
      render json: { success: 'Channel successfully added to favourites', favourite: @favourite, status: :created }
    else
      render json: { error: @favourite.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @favourite.destroy
      render json: { success: 'Channel successfully removed from favourites', status: :success }
    else
      render json: { error: favourite.errors, status: :unprocessable_entity }
    end
  end

  private

  def favourites_params
    params.require(:favourite).permit(:favourable_type, :favourable_id).tap do |param|
      param[:user_id] = User.first.id
    end
  end

  def set_favourite
    @favourite = Favourite.find_by(id: params[:id])
    render json: { error: 'Channel could not be found in favourites', status: :unprocessable_entity } if @favourite.nil?
  end
end
