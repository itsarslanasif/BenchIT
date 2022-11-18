class Api::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_workspace_in_session

  private

  def set_workspace_in_session
    session[:current_workspace_id] = Workspace.first.id
  end
end
