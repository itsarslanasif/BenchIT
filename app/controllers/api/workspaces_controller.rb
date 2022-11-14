class Api::WorkspacesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Workspace.all
  end

  def create
    @workspace = Workspace.new(workspace_params)
    puts @workspace.errors
    if @workspace.save
      puts "in create"

      render json: @workspace, status: 200
    else
      puts "in create"

      render json: @workspace.errors
    end
  end

  private

    def workspace_params
      params.permit(:company_name, :benchIT_URL, :organization_type, :capacity, :admin_role, :workspace_type)
    end
end
