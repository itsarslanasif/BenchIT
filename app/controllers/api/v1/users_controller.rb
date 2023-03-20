class Api::V1::UsersController < Api::ApiController
  skip_before_action :presence_of_api_token, :authenticate_api_with_token, :set_workspace_in_session, only: [:create]

  def index
    @users = User.all
    render json: @users
  end

  def create
    user = User.new(user_params)
    user.save!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  private

  def user_params
    params.permit(:name, :email).tap do |param|
      param[:jti] = SecureRandom.uuid
    end
  end
end
