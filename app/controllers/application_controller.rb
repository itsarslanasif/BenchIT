class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :set_locale_from_url
  rescue_from Exception, with: :render_error

  def index
    render template: 'application'
  end

  private

  def render_error(exception)
    if exception.instance_of?(ActiveRecord::RecordNotFound)
      render json: { success: false, error: 'Record Not found.' }, status: :not_found
    elsif exception.instance_of?(ActiveRecord::RecordInvalid)
      render json: { success: false, error: 'Record must exist.', message: exception.message }, status: :unprocessable_entity
    elsif exception.instance_of?(ActiveRecord::RecordNotSaved)
      render json: { success: false, error: 'Record Not saved.', message: exception.message }, status: :unprocessable_entity
    elsif exception.instance_of?(ActiveRecord::RecordNotUnique)
      render json: { success: false, error: 'Record Not Unique.', message: exception.message }, status: :unprocessable_entity
    elsif exception.instance_of?(ActiveRecord::RecordNotDestroyed)
      render json: { success: false, error: 'Record Not Destroyed.', message: exception.message }, status: :unprocessable_entity
    else
      render json: { success: false, error: 'Internal server error.' }, status: :internal_server_error
    end
  end
end
