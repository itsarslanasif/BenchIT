module Api
  class WorkspacesController < Api::ApiController
    before_action :find_workspace, only: %i[invite]
    before_action :find_user, only: %i[invite]

    def create
      @workspace = Workspace.new(workspace_params)

      if @workspace.save
        render json: @workspace, status: 200
      else
        render json: @workspace.errors
      end
    end

    def invite
      if @user && @workspace
        @token = Token.new.generate
        @invitable = Invitable.create!(user_id: @user.id,
                                      workspace_id: @workspace.id,
                                      token: @token, token_type: 'workspace_invitation')
        SendWorkspaceInvitationEmailJob.perform_later(@user.email, @workspace, @token)
      else
        redirect_to "#{self.request.base_url}/404"
      end
    end

    private

    def workspace_params
      params.permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
    end

    def invite_params
      params.permit(:email, :workspace_id, :token_type)
    end

    def find_workspace
      @workspace = Workspace.find(params[:workspace_id])
    end

    def find_user
      @user = User.find_by_email(params[:email])
    end
  end
end
