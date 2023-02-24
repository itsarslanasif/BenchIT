module ExceptionHandler
  extend ActiveSupport::Concern

  def error_data_for_exception(exception)
    {
      ActiveRecord::RecordNotFound => { message: I18n.t('application.render_error.not_found_error'), status: :not_found },
      ActiveRecord::RecordInvalid => { message: I18n.t('application.render_error.invalid_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotSaved => { message: I18n.t('application.render_error.not_saved_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotUnique => { message: I18n.t('application.render_error.unique_error'), status: :unprocessable_entity },
      ActiveRecord::RecordNotDestroyed => { message: I18n.t('application.render_error.not_destroy_error'), status: :unprocessable_entity },
      ActiveRecord::NotNullViolation => { message: I18n.t('application.render_error.not_null_violation_error'), status: :unprocessable_entity },
      ActiveRecord::SubclassNotFound => { message: I18n.t('application.render_error.sub_class_error'), status: :not_found },
      ActiveRecord::AssociationTypeMismatch => { message: I18n.t('application.render_error.association_type_error'), status: :unprocessable_entity },
      ActiveRecord::InverseOfAssociationNotFoundError => { message: I18n.t('application.render_error.inverse_association_error'),
                                                           status: :unprocessable_entity },
      ActiveRecord::HasManyThroughAssociationNotFoundError => { message: I18n.t('application.render_error.has_many_association_error'),
                                                                status: :unprocessable_entity },
      ActionController::ParameterMissing => { message: I18n.t('application.render_error.params_error'), status: :unprocessable_entity },
      ActionController::RoutingError => { message: I18n.t('application.render_error.routing_error'), status: :not_found },
      ActionController::UnknownFormat => { message: I18n.t('application.render_error.unknown_format_error'), status: :unprocessable_entity },
      ActionController::BadRequest => { message: I18n.t('application.render_error.bad_request_error'), status: :bad_request },
      ActionController::NotImplemented => { message: I18n.t('application.render_error.not_implemented_error'), status: :unprocessable_entity },
      ActionController::InvalidAuthenticityToken => { message: I18n.t('application.render_error.token_error'), status: :unprocessable_entity },
      ActionController::MissingFile => { message: I18n.t('application.render_error.missing_file_error'), status: :unprocessable_entity },
      ActionView::Template::Error => { message: I18n.t('application.render_error.template_error'), status: :unprocessable_entity },
      JSON::GeneratorError => { message: I18n.t('application.render_error.json_error'), status: :unprocessable_entity },
      I18n::InvalidLocaleData => { message: I18n.t('application.render_error.local_error'), status: :unprocessable_entity },
      CanCan::AccessDenied => { message: I18n.t('application.render_error.access_denied_error'), status: :unauthorized },
      NoMethodError => { message: I18n.t('application.render_error.no_method_error'), status: :unprocessable_entity },
      UnAuthorized => { message: I18n.t('application.render_error.unauthorized_error'), status: :unauthorized },
      PaginationError => { message: I18n.t('application.render_error.pagination_error'), status: :unprocessable_entity },
      ArgumentError => { message: I18n.t('application.render_error.argument_error'), status: :unprocessable_entity },
      SyntaxError => { message: I18n.t('application.render_error.syntax_error'), status: :unprocessable_entity },
      TypeError => { message: I18n.t('application.render_error.type_error'), status: :unprocessable_entity },
      IndexError => { message: I18n.t('application.render_error.index_error'), status: :unprocessable_entity },
      NameError => { message: I18n.t('application.render_error.name_error'), status: :unprocessable_entity }
    }[exception.class] || { message: I18n.t('application.render_error.server_error'), status: :internal_server_error }
  end
end
