class Api::ApiController < ApplicationController
  include DatabaseHandler

  skip_before_action :verify_authenticity_token
  before_action :presence_of_api_token
  before_action :authenticate_api_with_token
  before_action :set_workspace_in_session
  before_action :set_profile

  attr_reader :current_user

  private

  def set_workspace_in_session
    if session[:current_workspace_id].nil?
      render json: { success: false, error: t('api.no_workspace') }, status: :unprocessable_entity
    else
      Current.workspace = Workspace.find(session[:current_workspace_id])
      if Current.workspace.id != session[:current_workspace_id]
        switch_database
        workspace = Workspace.find(session[:current_workspace_id])
        establish_connection_to_workspace_db(workspace.company_name.downcase)
      end
    end
  end

  def set_profile
    Current.profile = Current.user.profiles.find_by(workspace_id: Current.workspace)
  end

  def presence_of_api_token
    return unless request.headers['Authorization'].nil?

    raise UnAuthorized, 'unauthorized'
  end

  def authenticate_api_with_token
    token = request.headers['Authorization'].split[1]
    jwt_payload = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base))
    @current_user = User.find(jwt_payload[0]['sub'])

    raise UnAuthorized, 'unauthorized' unless @current_user

    Current.user = @current_user
  end

  def current_profile
    @current_profile ||= Current.profile
  end

  def current_workspace
    @current_workspace ||= Current.workspace
  end
end
