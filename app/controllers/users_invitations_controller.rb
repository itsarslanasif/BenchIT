class UsersInvitationsController < Devise::InvitationsController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_no_authentication, only: [:update]

  def edit
    if params[:invitation_token]
      redirect_to "#{request.base_url}/password_form?invitation_token=#{params[:invitation_token]}"
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  def create
    User.invite!(invite_params)
    render json: { success: ['User created.'] }, status: :created
  end

  def update
    user = User.accept_invitation!(accept_invitation_params)

    if @user.errors.empty?
      render json: { success: ['User updated.'] }, status: :accepted
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def invite_params
    params.permit(:email, :invitation_token, :provider, :skip_invitation)
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end
