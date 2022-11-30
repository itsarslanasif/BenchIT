class Api::V1::FavouritesController < Api::ApiController

  def create
    already_favourite=Favourite.where(user_id: params[:user_id],favourable_type: params[:favourable_type],favourable_id: params[:favourable_id]).pluck(:id)
    if already_favourite.empty?
      favourite=Favourite.new(user_id:params[:user_id],favourable_type: params[:favourable_type],favourable_id:params[:favourable_id]).save
      if favourite
        return render status: 201, json: {message: 'Succesfully added to favourites' ,status_code: 2}
      else
        render json: {message: "Cannot Add to Favoruites",status_code: 1, status: :unprocessable_entity }
      end
    else
      render json: {message: "Already Favoruite",status_code: 1, status: :unprocessable_entity }
    end
  end

  def destroy
    @favourite=Favourite.find_by_id(params[:id])
    if @favourite
      if @favourite.destroy
        render status: 201, json: {message: 'Succesfully removed from favourites' ,status_code: 2}
      else
        render json: {message: "Cannot Remove from favourites",status_code: 1, status: :unprocessable_entity }
      end
    else
      render json: {message: "Cannot found in favourites",status_code: 1, status: :unprocessable_entity }
    end
  end

  private

  def favourites_params
    params.permit(:user_id,:favourable_type,:favourable_id)
  end

end
