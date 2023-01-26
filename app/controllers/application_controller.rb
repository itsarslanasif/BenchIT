class ApplicationController < ActionController::Base
  require 'sidekiq/api'
  protect_from_forgery with: :exception

  around_action :set_locale_from_url
  rescue_from Exception, with: :render_error

  def index
    render template: 'application'
  end

  private

  def render_error(exception)
    case exception
    when ActiveRecord::RecordNotFound
      render json: { success: false, error_message: 'Record Not Found.' }, status: :not_found
    when ActiveRecord::RecordInvalid
      render json: { success: false, error_message: 'Record Invalid.', message: exception.message }, status: :unprocessable_entity
    when ActiveRecord::RecordNotSaved
      render json: { success: false, error_message: 'Record Not saved', message: exception.message }, status: :unprocessable_entity
    when NoMethodError
      render json: { success: false, error_message: 'No Method Error.', message: exception.message }, status: :unprocessable_entity
    when ActiveRecord::RecordNotUnique
      render json: { success: false, error_message: 'Record Not Unique.', message: exception.message }, status: :unprocessable_entity
    when ActiveRecord::RecordNotDestroyed
      render json: { success: false, error_message: 'Record Not Destroyed', message: exception.message }, status: :unprocessable_entity
    else
      render json: { success: false, error_message: 'Internal Server Error.' }, status: :internal_server_error
    end
  end
end
