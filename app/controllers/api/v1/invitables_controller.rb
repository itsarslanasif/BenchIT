class Api::V1::InvitablesController < Api::ApiController
  skip_before_action :presence_of_api_token, :authenticate_api_with_token, :set_workspace_in_session, :set_profile,
                     only: %i[accept_invitation]
  before_action :check_mail_list, only: %i[create]
  before_action :set_invitable, only: %i[update accept_invitation]

  def index
    @invitables = current_workspace.invitables
    render json: @invitables
  end

  def create
    ActiveRecord::Base.transaction do
      params[:mail_list].each do |email|
        @invitable = Invitable.new(email: email, invitation_type: params[:invitable_type])
        check_user_and_profile(email)
      end
    end

    render json: { success: true, message: t('.success') }, status: :ok
  end

  def update
    @invitable.update!(status: params[:status])
    WorkspaceMailer.workspace_invitation_mail(@invitable).deliver_now if @invitable.approved?
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def accept_invitation
    if @invitable.approved?
      ActiveRecord::Base.transaction do
        @invitable.accepted!
        create_user_or_profile
      end
    end

    redirect_to ENV.fetch('VITE_APP_SERVER_URL', nil)
  end

  private

  def set_invitable
    @invitable = Invitable.find(params[:id])
  end

  def check_mail_list
    render json: { success: false, message: t('.failure') }, status: :unprocessable_entity if params[:mail_list].blank?
  end

  def create_user_or_profile
    name = @invitable.email.split('@').first
    @user = User.find_or_create_by!(email: @invitable.email)
    @profile = @user.profiles.create!(username: name, workspace_id: @invitable.workspace_id, role: @invitable.invitation_type)
  end

  def check_user_and_profile(email)
    @user = User.find_by(email: email)
    @invitable.has_account = @user.nil? ? :no : :yes
    @profile = @user&.profiles&.find_by(workspace_id: current_workspace.id)
    send_invitation if @profile.nil?
  end

  def send_invitation
    if PROFILE_ROLES[0, 3].include?(current_profile.role)
      @invitable.approved!
      WorkspaceMailer.workspace_invitation_mail(@invitable).deliver_now
    else
      @invitable.save!
    end
  end
end
