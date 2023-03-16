class ApplicationController < ActionController::Base
  require 'sidekiq/api'
  include ExceptionHandler

  protect_from_forgery with: :exception

  around_action :set_locale_from_url
  #rescue_from Exception, with: :render_error

  def index
    render template: 'application'
  end

  private

  def render_error(exception)
    error_data = error_data_for_exception(exception)
    render json: { success: false, error: error_data[:message], message: exception.message }, status: error_data[:status]
  end
end

class UnAuthorized < StandardError; end

class PaginationError < StandardError; end
