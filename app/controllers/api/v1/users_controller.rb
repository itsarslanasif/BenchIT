class Api::V1::UsersController < Api::ApiController
  skip_before_action :presence_of_api_token, :authenticate_api_with_token, :set_workspace_in_session, :set_profile,
                     only: %i[create verify_email]
  before_action :set_user, :verify_token, only: %i[verify_email]

  def index
    @users = User.all
    render json: @users
  end

  def create
    user = User.new(user_params)
    user.save!
    AccountMailer.verification_email(user).deliver_now
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def verify_email
    @user.update!(verified: true, verification_token: nil)
    redirect_to ENV.fetch('VITE_APP_SERVER_URL', nil)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password).tap do |param|
      param[:verification_token] = SecureRandom.hex(32)
      param[:verified] = false
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def verify_token
    render json: { success: false, message: t('.failure') }, status: :unprocessable_entity if @user.verification_token.blank?
  end
end
