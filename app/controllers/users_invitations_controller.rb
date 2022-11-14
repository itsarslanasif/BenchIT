class UsersInvitationsController < Devise::InvitationsController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_no_authentication, only: [:update ]

  def create
    User.invite!(invite_params)
    render json: { success: ['User created.'] }, status: :created
  end

  def edit
    # redirect_to "#{client_api_url}?invitation_token=#{params[:invitation_token]}"
    redirect_to "http://127.0.0.1:5100/password_form?invitation_token=#{params[:invitation_token]}"
  end

  def update
    user = User.accept_invitation!(accept_invitation_params)
    # if @user.errors.empty?
      render json: { success: ['User updated.'] }, status: :accepted
    # else
      # render json: { errors: user.errors.full_messages },
            #  status: :unprocessable_entity
    # end
  end

  private

  def invite_params
    params.permit(:email, :invitation_token, :provider, :skip_invitation)
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end

end
