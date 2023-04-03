class Api::V1::InvitesController < Api::ApiController
  skip_before_action :presence_of_api_token, :authenticate_api_with_token, :set_workspace_in_session, :set_profile,
                     only: %i[accept_invitation]
  before_action :check_mail_list, only: %i[create]
  before_action :set_invitable, only: %i[update accept_invitation]

  def create
    ActiveRecord::Base.transaction do
      params[:mail_list].each do |email|
        @invite = Invite.new(email: email, invitation_type: params[:invitation_type], reason: params[:reason])
        check_user_and_profile(email)
      end
    end

    render json: { success: true, message: t('.success') }, status: :ok
  end

  def update
    @invite.update!(status: params[:status])
    WorkspaceMailer.workspace_invitation_mail(@invite).deliver_now if @invite.approved?
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def accept_invitation
    if @invite.approved?
      ActiveRecord::Base.transaction do
        @invite.accepted!
        create_user_or_profile
      end
    end

    redirect_to ENV.fetch('VITE_APP_SERVER_URL', nil)
  end

  private

  def set_invitable
    @invite = Invite.find(params[:id])
  end

  def check_mail_list
    render json: { success: false, message: t('.failure') }, status: :unprocessable_entity if params[:mail_list].blank?
  end

  def create_user_or_profile
    name = @invite.email.split('@').first
    @user = User.find_or_create_by!(email: @invite.email)
    @profile = @user.profiles.create!(username: name, workspace_id: @invite.workspace_id, role: @invite.invitation_type)
  end

  def check_user_and_profile(email)
    @user = User.find_by(email: email)
    @invite.has_account = @user.present?
    @profile = @user&.profiles&.find_by(workspace_id: current_workspace.id)
    send_invitation if @profile.nil?
  end

  def send_invitation
    if PROFILE_ROLES[0, 3].include?(current_profile.role)
      @invite.approved!
      WorkspaceMailer.workspace_invitation_mail(@invite).deliver_now
    else
      @invite.save!
    end
  end
end
