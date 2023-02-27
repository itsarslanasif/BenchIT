module ExceptionHandler
  extend ActiveSupport::Concern

  def error_data_for_exception(exception)
    {
      ActiveRecord::RecordNotFound => prepare_local('not_found_error', 'not_found'),
      ActiveRecord::RecordInvalid => prepare_local('invalid_error', 'unprocessable_entity'),
      ActiveRecord::RecordNotSaved => prepare_local('not_saved_error', 'unprocessable_entity'),
      ActiveRecord::RecordNotUnique => prepare_local('unique_error', 'unprocessable_entity'),
      ActiveRecord::RecordNotDestroyed => prepare_local('not_destroy_error', 'unprocessable_entity'),
      ActiveRecord::NotNullViolation => prepare_local('not_null_violation_error', 'unprocessable_entity'),
      ActiveRecord::SubclassNotFound => prepare_local('sub_class_error', 'not_found'),
      ActiveRecord::AssociationTypeMismatch => prepare_local('association_type_error', 'unprocessable_entity'),
      ActiveRecord::InverseOfAssociationNotFoundError => prepare_local('inverse_association_error', 'unprocessable_entity'),
      ActiveRecord::HasManyThroughAssociationNotFoundError => prepare_local('has_many_association_error', 'unprocessable_entity'),
      ActionController::ParameterMissing => prepare_local('params_error', 'unprocessable_entity'),
      ActionController::RoutingError => prepare_local('routing_error', 'not_found'),
      ActionController::UnknownFormat => prepare_local('unknown_format_error', 'unprocessable_entity'),
      ActionController::BadRequest => prepare_local('bad_request_error', 'bad_request'),
      ActionController::NotImplemented => prepare_local('not_implemented_error', 'unprocessable_entity'),
      ActionController::MissingFile => prepare_local('missing_file_error', 'unprocessable_entity'),
      ActionView::Template::Error => prepare_local('template_error', 'unprocessable_entity'),
      JSON::GeneratorError => prepare_local('json_error', 'unprocessable_entity'),
      I18n::InvalidLocaleData => prepare_local('local_error', 'unprocessable_entity'),
      CanCan::AccessDenied => prepare_local('access_denied_error', 'unauthorized'),
      NoMethodError => prepare_local('no_method_error', 'unprocessable_entity'),
      UnAuthorized => prepare_local('unauthorized_error', 'unauthorized'),
      PaginationError => prepare_local('pagination_error', 'unprocessable_entity'),
      ArgumentError => prepare_local('argument_error', 'unprocessable_entity'),
      SyntaxError => prepare_local('syntax_error', 'unprocessable_entity'),
      TypeError => prepare_local('type_error', 'unprocessable_entity'),
      IndexError => prepare_local('index_error', 'unprocessable_entity'),
      NameError => prepare_local('name_error', 'unprocessable_entity')
    }[exception.class] || prepare_local('server_error', 'internal_server_error')
  end

  private

  def prepare_local(error_name, status_code)
    { message: I18n.t("application.render_error.#{error_name}"), status: status_code.to_sym }
  end
end
