# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_action :verify_authenticity_token

  def check_auth
    if user_signed_in?
      render json: current_user
    else
      render json: { message: 'Something went wrong' }, status: :unprocessable_entity
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
    redirect_to "#{request.base_url}/sign_in"
  end

  def log_out_failure
    render json: { message: 'Something went wrong' }, status: :unauthorized
  end
end
