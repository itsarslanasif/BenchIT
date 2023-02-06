class Api::V1::WorkspacesController < Api::ApiController
  before_action :find_workspace, only: %i[invite switch_workspace]
  before_action :find_profile, only: %i[switch_workspace]
  before_action :check_profile, only: %i[invite]
  skip_before_action :set_workspace_in_session, only: %i[index switch_workspace]
  skip_before_action :set_profile, only: %i[index switch_workspace]

  def index
    @workspaces = Current.user.workspaces
  end

  def create
    @workspace = Workspace.new(workspace_params)

    if @workspace.save
      render json: @workspace, status: :ok
    else
      render json: { error: 'Error while creating workspace', errors: @workspace.errors }, status: :unprocessable_entity
    end
  end

  def invite
    @token = Token.new.generate
    create_invitable if @user.present?
    WorkspaceMailer.send_email(params[:email], @workspace, @token).deliver!
    render json: { message: "#{params[:email]} is sucessfully invited to #{@workspace.company_name}" }, status: :ok
  end

  def create_invitable
    @invitable = Invitable.create(user_id: @user.id, workspace_id: @workspace.id,
                                  token: @token, token_type: 'workspace_invitation')

    return unless @invitable.errors.any?

    render json: {
      error: 'There was an error in inviting the user to workspace',
      errors: @invitable.errors
    }, status: :unprocessable_entity
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

    render json: { error: 'Workspace not found' }, status: :not_found if @workspace.nil?
  end

  def find_profile
    @profile = Current.user.profiles.find_by(workspace_id: @workspace)

    render json: { error: 'You are not a part of this workspace' }, status: :unprocessable_entity if @profile.nil?
  end

  def check_profile
    @user = User.find_by(email: params[:email])
    return if @user.blank?
    return if @user.profiles.find_by(workspace_id: @workspace).blank?

    render json: { error: t('.error') }, status: :unprocessable_entity
  end
end
