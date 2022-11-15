class Api::UsersController < Api::ApiController
  before_action :set_user, only: [:show]
  def index
    @users = User.all
    render json: @users
  end

  private
  def set_user
    @receiver = User.find_by_id(params[:id])
    return if @receiver.present?

    render json: { json: @receiver.errors, status: :unprocessable_entity }
  end
end
