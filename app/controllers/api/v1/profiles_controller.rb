class Api::V1::ProfilesController < Api::ApiController
  before_action :set_workspace, only: %i[index create show]
  before_action :check_profile_already_exists, only: %i[create]
  before_action :set_receiver, only: %i[show]
  before_action :set_previous_direct_messages, only: %i[previous_direct_messages]
  before_action :check_user_member_of_workspace, only: %i[show]

  def index
    @profiles = if params[:query].presence
                  Profile.search(
                    params[:query],
                    where: { workspace_id: @workspace.id },
                    match: :word_start, misspellings: false
                  )
                else
                  @workspace.profiles.all
                end
    @profiles = @profiles.reorder(username: :asc) if params[:sort] == 'asc'
    @profiles = @profiles.reorder(username: :desc) if params[:sort] == 'desc'
  end

  def show
    @profile = @workspace.profiles.find(params[:id])
  end

  def create
    @profile = current_user.profiles.new(profile_params)

    if @profile.save
      render json: "Profile Added to #{@workspace.company_name}"
    else
      render json: { errors: @profile.errors, message: 'There was an error creating the profile' }, status: :unprocessable_entity
    end
  end

  def previous_direct_messages
    dm_users_ids = BenchConversation.where(id: @bench_conversations_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
    @profiles = Profile.where(id: dm_users_ids)
  end

  private

  def set_workspace
    @workspace = Workspace.find_by(id: params[:workspace_id])

    return render json: { message: 'Workspace Not Found.' }, status: :not_found if @workspace.nil?
  end

  def profile_params
    params.require(:profile).permit(:username, :description).tap do |param|
      param[:workspace_id] = params[:workspace_id]
    end
  end

  def check_user_member_of_workspace
    return if Current.workspace.id == params[:workspace_id].to_i

    render json: { message: 'You are not member of specified  workspace.' }, status: :unprocessable_entity
  end

  def check_profile_already_exists
    return if current_user.profiles.find_by(workspace_id: params[:workspace_id]).nil?

    render json: { message: 'You already have a profile in this workspace.' }, status: :unprocessable_entity
  end

  def set_receiver
    @receiver = Profile.find(params[:id])

    render json: { message: 'You cannot access this profile.' }, status: :unprocessable_entity unless @receiver.workspace_id == Current.workspace.id
  end

  def set_previous_direct_messages
    conversation_ids = BenchConversation.last_dm_message
    return render json: [Current.profile] if conversation_ids.empty?

    @bench_conversations_ids = ConversationMessage.last_dm_message(conversation_ids)
    return render json: [Current.profile] if @bench_conversations_ids.empty?
  end
end
