class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :set_locale_from_url
  rescue_from Exception, with: :render_error

  def index
    render template: 'application'
  end

  private

  def render_error(exception)
    error_map = {
      ActiveRecord::RecordNotFound => { message: 'Record Not Found.', status: :not_found },
      ActiveRecord::RecordInvalid => { message: 'Record Invalid.', status: :unprocessable_entity },
      ActiveRecord::RecordNotSaved => { message: 'Record Not saved', status: :unprocessable_entity },
      NoMethodError => { message: 'No Method Error.', status: :unprocessable_entity },
      ActiveRecord::RecordNotUnique => { message: 'Record Not Unique.', status: :unprocessable_entity },
      ActiveRecord::RecordNotDestroyed => { message: 'Record Not Destroyed', status: :unprocessable_entity },
      PaginationError => { message: 'Page not found.', status: :unprocessable_entity },
      :else => { message: 'Internal Server Error.', status: :internal_server_error }
    }
    error_data = error_map[exception.class] || error_map[:else]
    render json: { success: false, error: error_data[:message], message: exception.message }, status: error_data[:status]
  end
end
