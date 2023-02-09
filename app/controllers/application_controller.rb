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
    error_map = {
      ActiveRecord::RecordNotFound => { message: t('.found_error'), status: :not_found },
      ActiveRecord::RecordInvalid => { message: t('.invalid_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotSaved => { message: 'Record Not saved', status: :unprocessable_entity },
      NoMethodError => { message: t('.method_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotUnique => { message: t('.unique_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotDestroyed => { message: t('.destroy_error'), status: :unprocessable_entity },
      PaginationError => { message: t('.pagination_error'), status: :unprocessable_entity },
      :else => { message: t('.server_error'), status: :internal_server_error }
    }
    error_data = error_map[exception.class] || error_map[:else]
    render json: { success: false, error: error_data[:message], message: exception.message }, status: error_data[:status]
  end
end
