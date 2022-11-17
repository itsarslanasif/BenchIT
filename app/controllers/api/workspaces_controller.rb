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
      @token = Tokens::Token.new.generate
      @invitable = Invitable.create(user_id: @user.id, user_email: @user.email,
                                    workspace_id: @workspace.id, token: @token,
                                    token_type: params[:token_type], invitation_sent_by: @workspace.company_name,
                                    invitation_sent_at: Time.now)
      SendWorkspaceInvitationEmailJob.perform_later(@user.email, @workspace, @token)
    end

    private

    def workspace_params
      params.permit(:company_name, :benchIT_URL, :organization_type, :capacity, :admin_role, :workspace_type)
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
