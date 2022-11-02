class WorkspacesController < ApplicationController

  def index
    @workspaces = Workspace.all

    render json: @workspaces
  end

  def create
    @workspace = Workspace.new(workspace_params)

    if @workspace.save
      render json: @workspace
    else
      render json: @workspace.errors
    end
  end

  private
    def workspace_params
      params.permit(:company_name, :slack_URL, :organization_type, :capacity,:admin_role,:workspace_type)
    end
end
