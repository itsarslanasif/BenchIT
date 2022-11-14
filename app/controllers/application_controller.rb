class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :set_locale_from_url
  rescue_from Exception, with: :render_error

  def index
    render template: 'application'
  end

  private

  def render_error(e)
    if e.instance_of?(ActiveRecord::RecordNotFound)
      render json: { success: false, error: 'Not found' }.to_json, status: :not_found
    else
      render json: { success: false, error: 'Internal server error' }.to_json, status: :internal_server_error
    end
  end
end
