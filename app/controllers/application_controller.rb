class ApplicationController < ActionController::Base
  require 'sidekiq/api'
  include Pundit::Authorization
  protect_from_forgery with: :exception

  around_action :set_locale_from_url
  rescue_from Exception, with: :render_error

  def index
    render template: 'application'
  end

  private

  def render_error(exception)
    error_map = {
      ActiveRecord::RecordNotFound => { message: I18n.t('application.render_error.not_found_error'), status: :not_found },
      ActiveRecord::RecordInvalid => { message: I18n.t('application.render_error.invalid_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotSaved => { message: I18n.t('application.render_error.not_saved_error'), status: :unprocessable_entity },
      NoMethodError => { message: I18n.t('application.render_error.no_method_error'), status: :unprocessable_entity },
      UnAuthorized => { message: I18n.t('application.render_error.unauthorized_error'), status: :unauthorized },
      Pundit::NotAuthorizedError => { message: I18n.t('application.render_error.unauthorized_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotUnique => { message: I18n.t('application.render_error.unique_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotDestroyed => { message: I18n.t('application.render_error.not_destroy_error'), status: :unprocessable_entity },
      PaginationError => { message: I18n.t('application.render_error.pagination_error'), status: :unprocessable_entity },
      ArgumentError => { message: I18n.t('application.render_error.argument_error'), status: :unprocessable_entity },
      SyntaxError => { message: I18n.t('application.render_error.syntax_error'), status: :unprocessable_entity },
      TypeError => { message: I18n.t('application.render_error.type_error'), status: :unprocessable_entity },
      IndexError => { message: I18n.t('application.render_error.index_error'), status: :unprocessable_entity },
      NameError => { message: I18n.t('application.render_error.name_error'), status: :unprocessable_entity },
      :else => { message: I18n.t('application.render_error.server_error'), status: :internal_server_error }
    }
    error_data = error_map[exception.class] || error_map[:else]
    render json: { success: false, error: error_data[:message], message: exception.message }, status: error_data[:status]
  end
end

class UnAuthorized < StandardError; end

class PaginationError < StandardError; end
