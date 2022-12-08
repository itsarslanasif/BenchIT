class Api::V1::FavouritesController < Api::ApiController
  before_action :check_favourite, only: %i[create]
  before_action :set_favourite, only: %i[destroy]

  def create
    favourite = Favourite.new(favourites_params)
    if favourite.save
      return render status: 201, json: { success: 'Succesfully added to favourites', favourite: favourite}
    else
      render json: { error: favourite.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @favourite.destroy
      render status: 201, json: { success: 'Succesfully removed from favourites' }
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

  def check_favourite
    already_favourite = Favourite.already_favourite(favourites_params)
    if already_favourite.present?
      render json: { error: 'Already Favoruite', status: :unprocessable_entity }
    end
  end

  def set_favourite
    @favourite = Favourite.find_by(id: params[:id])
    if @favourite.nil?
      render json: { error: 'Cannot be found in favourites', status: :unprocessable_entity }
    end
  end
end
