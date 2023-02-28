module CanAuthorization
  extend ActiveSupport::Concern

  def authorize_action(action, object)
    action.eql?('show') ? (authorize! :get, object) : (authorize! action.to_sym, object)
  end
end
