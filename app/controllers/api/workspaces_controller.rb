module Api
  class WorkspacesController < Api::ApiController
    # skip_before_action :verify_authenticity_token
    before_action :find_workspace, only: %i[invite]

    def index
      render json: Workspace.all
    end

    def create
      @workspace = Workspace.new(workspace_params)
      if @workspace.save
        render json: @workspace, status: 200
      else
        render json: @workspace.errors
      end
    end

    def invite
      @email = params[:email]
      SendWorkspaceInvitationEmailJob.perform_later(@email, @workspace)
    end

    private

    def workspace_params
      params.permit(:company_name, :benchIT_URL, :organization_type, :capacity, :admin_role, :workspace_type)
    end

    def invite_params
      params.permit(:email, :workspace_id)
    end

    def find_workspace
      @workspace = Workspace.find(params[:workspace_id])
    end
  end
end
