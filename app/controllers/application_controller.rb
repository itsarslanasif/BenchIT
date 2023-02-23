class ApplicationController < ActionController::Base
  require 'sidekiq/api'
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

  def error_data_for_exception(exception)
    {
      ActiveRecord::RecordNotFound => { message: I18n.t('application.render_error.not_found_error'), status: :not_found },
      ActiveRecord::RecordInvalid => { message: I18n.t('application.render_error.invalid_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotSaved => { message: I18n.t('application.render_error.not_saved_error'), status: :unprocessable_entity },
      NoMethodError => { message: I18n.t('application.render_error.no_method_error'), status: :unprocessable_entity },
      UnAuthorized => { message: I18n.t('application.render_error.unauthorized_error'), status: :unauthorized },
      ActiveRecord::RecordNotUnique => { message: I18n.t('application.render_error.unique_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotDestroyed => { message: I18n.t('application.render_error.not_destroy_error'), status: :unprocessable_entity },
      ActiveRecord::NotNullViolation => { message: t('application.render_error.not_null_violation_error'), status: :bad_request },
      PaginationError => { message: I18n.t('application.render_error.pagination_error'), status: :unprocessable_entity },
      ArgumentError => { message: I18n.t('application.render_error.argument_error'), status: :unprocessable_entity },
      SyntaxError => { message: I18n.t('application.render_error.syntax_error'), status: :unprocessable_entity },
      TypeError => { message: I18n.t('application.render_error.type_error'), status: :unprocessable_entity },
      IndexError => { message: I18n.t('application.render_error.index_error'), status: :unprocessable_entity },
      NameError => { message: I18n.t('application.render_error.name_error'), status: :unprocessable_entity },
      CanCan::AccessDenied => { message: I18n.t('application.render_error.unauthorized_error'), status: :unauthorized },
      :else => { message: I18n.t('application.render_error.server_error'), status: :internal_server_error }
    }[exception.class] || error_data_for_else
  end

  def error_data_for_else
    { message: I18n.t('application.render_error.server_error'), status: :internal_server_error }
  end
end

class UnAuthorized < StandardError; end

class PaginationError < StandardError; end
