class Api::V1::FavouritesController < Api::ApiController
  before_action :check_favourite, only: %i[create]
  before_action :set_favourite, only: %i[destroy]

  def create
    favourite = Favourite.new(user:@current_user, favourable_type: params[:favourable_type], favourable_id:params[:favourable_id])
    if favourite.save
      return render status: 201, json: { success: 'Succesfully added to favourites', favourite_id: favourite.id}
    else
      render json: { error: 'Cannot Add to Favoruites', status: :unprocessable_entity }
    end
  end

  def destroy
    if @favourite.destroy
      render status: 201, json: { success: 'Succesfully removed from favourites' }
    else
      render json: { error: 'Cannot Remove from favourites', status: :unprocessable_entity }
    end
  end

  private

  def favourites_params
    params.permit(:favourable_type,:favourable_id)
  end

  def check_favourite
    @current_user = Current.user
    already_favourite = Favourite.where(user_id:@current_user, favourable_type: params[:favourable_type], favourable_id: params[:favourable_id]).pluck(:id)
    if already_favourite.empty?
    else
      render json: { error: 'Already Favoruite', status: :unprocessable_entity }
    end
  end

  def set_favourite
    @favourite = Favourite.find_by_id(params[:id])
    if @favourite.nil?
      render json: { error: 'Cannot found in favourites', status: :unprocessable_entity }
    end
  end
end
