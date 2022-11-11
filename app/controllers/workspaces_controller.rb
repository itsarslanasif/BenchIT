class WorkspacesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    byebug
    @workspace = Workspace.new(workspace_params)
    if @workspace.save
      render json: @workspace
    else
      render json: @workspace.errors
    end
  end

  private

    def workspace_params
      params.require(:workspace).permit(:company_name, :benchIT_URL, :organization_type, :capacity, :admin_role, :workspace_type)
    end
end
