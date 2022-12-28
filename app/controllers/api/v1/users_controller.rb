class Api::V1::UsersController < Api::ApiController
  def index
    @users = User.all
    render json: @users
  end
end
