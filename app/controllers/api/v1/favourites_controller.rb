class Api::V1::FavouritesController < Api::ApiController

  def create
    current_user = User.first
    already_favourite = Favourite.where(user_id:current_user, favourable_type: params[:favourable_type], favourable_id: params[:favourable_id]).pluck(:id)
    if already_favourite.empty?
      favourite = Favourite.new(user:current_user, favourable_type: params[:favourable_type], favourable_id:params[:favourable_id])
      if favourite.save
        return render status: 201, json: { success: 'Succesfully added to favourites', favourite_id: favourite.id}
      else
        render json: { error: 'Cannot Add to Favoruites', status: :unprocessable_entity }
      end
    else
      render json: { error: 'Already Favoruite', status: :unprocessable_entity }
    end
  end

  def destroy
    @favourite = Favourite.find_by_id(params[:id])
    if @favourite
      if @favourite.destroy
        render status: 201, json: { success: 'Succesfully removed from favourites' }
      else
        render json: { error: 'Cannot Remove from favourites', status: :unprocessable_entity }
      end
    else
      render json: { error: 'Cannot found in favourites', status: :unprocessable_entity }
    end
  end

  private

  def favourites_params
    params.permit(:favourable_type,:favourable_id)
  end
end
