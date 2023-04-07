# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_action :verify_authenticity_token

  def check_auth
    if user_signed_in? && @current_user.verified?
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(_resource, _opts = {})
    render json: { message: 'You are logged in.', user: current_user }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return unless current_user

    log_out_failure
  end

  def log_out_success
    ActiveRecord::Base.establish_connection(:development)
    redirect_to helpers.sign_in_url
  end

  def log_out_failure
    render json: { success: false, message: I18.t('users.sessions.log_out_failure.failure') }, status: :unauthorized
  end
end
