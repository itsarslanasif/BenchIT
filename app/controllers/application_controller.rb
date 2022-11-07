class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RequestExceptionHandler
  include Pundit::Authorization
  include SwitchLocale

  skip_before_action :verify_authenticity_token
  before_action :set_current_user, unless: :devise_controller?
  around_action :switch_locale
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def set_current_user
    @user ||= current_user
    Current.user = @user
  end

  def pundit_user
    {
      user: Current.user,
      account: Current.account,
      account_user: Current.account_user
    }
  end
end
