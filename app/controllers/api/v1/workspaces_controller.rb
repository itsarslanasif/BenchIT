class Api::V1::WorkspacesController < Api::ApiController
  before_action :find_workspace, only: %i[invite]
  before_action :find_user, only: %i[invite]

  def create
    @workspace = Workspace.new(workspace_params)

    if @workspace.save
      render json: @workspace, status: :ok
    else
      render json: @workspace.errors
    end
  end

  def invite
    @token = Token.new.generate
    @invitable = Invitable.create!(user_id: @user.id, workspace_id: @workspace.id,
                                   token: @token, token_type: 'workspace_invitation')
    SendWorkspaceInvitationEmailJob.perform_later(@user.email, @workspace, @token)

    render json: { message: "#{@user.email} is sucessfully invited to #{@workspace.company_name}" }, status: :ok
  end

  private

  def workspace_params
    params.require(:workspace).permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
  end

  def find_workspace
    @workspace = Workspace.find_by(id: params[:id])

    render json: { message: 'Workspace not found' }, status: :not_found if @workspace.nil?
  end

  def find_user
    @user = User.find_by(email: params[:email])

    render json: { message: 'Email not found' }, status: :not_found if @user.nil?
  end
end
