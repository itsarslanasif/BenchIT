class Api::V1::WorkspacesController < Api::ApiController
  before_action :find_workspace, only: %i[invite switch_workspace]
  before_action :find_profile, only: %i[switch_workspace]
  before_action :find_user, only: %i[invite]
  skip_before_action :set_workspace_in_session, only: %i[index switch_workspace]
  skip_before_action :set_profile, only: %i[index switch_workspace]

  def index
    render json: { workspaces: Current.user.workspaces }, status: :ok
  end

  def create
    @workspace = Workspace.new(workspace_params)

    if @workspace.save
      render json: @workspace, status: :ok
    else
      render json: { error_message: 'Error while creating workspace', errors: @workspace.errors }, status: :unprocessable_entity
    end
  end

  def invite
    @token = Token.new.generate
    @invitable = Invitable.create(user_id: @user.id, workspace_id: @workspace.id,
                                  token: @token, token_type: 'workspace_invitation')

    if @invitable.errors.any?
      render json: {
        error_message: 'There was an error in inviting the user to workspace',
        errors: @invitable.errors
      }, status: :unprocessable_entity
    end
    SendWorkspaceInvitationEmailJob.perform_later(@user.email, @workspace, @token)

    render json: { message: "#{@user.email} is sucessfully invited to #{@workspace.company_name}" }, status: :ok
  end

  def switch_workspace
    session[:current_workspace_id] = @workspace.id
  end

  private

  def workspace_params
    params.require(:workspace).permit(:company_name, :bench_it_url, :organization_type, :capacity, :admin_role, :workspace_type)
  end

  def find_workspace
    @workspace = Workspace.find_by(id: params[:id])

    render json: { error_message: 'Workspace not found' }, status: :not_found if @workspace.nil?
  end

  def find_profile
    @profile = Current.user.profiles.find_by(workspace_id: @workspace)

    render json: { error_message: 'You are not a part of this workspace' }, status: :unprocessable_entity if @profile.nil?
  end

  def find_user
    @user = User.find_by(email: params[:email])

    render json: { error_message: 'Email not found' }, status: :not_found if @user.nil?
  end
end
