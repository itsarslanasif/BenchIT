class Api::V1::ProfilesController < Api::ApiController
  before_action :set_workspace, only: %i[index create show update]
  before_action :check_profile_already_exists, only: %i[create]
  before_action :set_previous_direct_messages, only: %i[previous_direct_messages]
  before_action :check_user_member_of_workspace, only: %i[show update]
  before_action :find_profile, only: %i[show update]

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

  def show; end

  def create
    @profile = current_user.profiles.new(profile_params)

    if @profile.save
      render json: { message: "Profile Added to #{@workspace.company_name}" }, status: :ok
    else
      render json: { errors: @profile.errors, error: 'There was an error creating the profile' }, status: :unprocessable_entity
    end
  end

  def update
    if (@profile = Current.profile.update(profile_params))
      render json: { message: 'Profile Updated Successfully.' }, status: :ok
    else
      render json: { errors: @profile.errors, error: 'There was an error updating the profile' }, status: :unprocessable_entity
    end
  end

  def previous_direct_messages
    @profiles = Profile.where(id: @dm_users_ids)
  end

  private

  def find_profile
    @profile = Profile.find(params[:id])
  end

  def set_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def profile_params
    params.require(:profile).permit(
      :username,
      :description,
      :recording,
      :profile_image,
      :role,
      :display_name,
      :title,
      :text_status,
      :emoji_status,
      :time_zone,
      :pronounce_name,
      :phone,
      :skype
    ).tap do |param|
      param[:workspace_id] = params[:workspace_id]
    end
  end

  def check_user_member_of_workspace
    return if Current.workspace.id.eql?(params[:workspace_id].to_i)

    render json: { error: 'You are not member of specified  workspace.' }, status: :unauthorized
  end

  def check_profile_already_exists
    return if current_user.profiles.find_by(workspace_id: params[:workspace_id]).nil?

    render json: { error: 'You already have a profile in this workspace.' }, status: :unprocessable_entity
  end

  def set_previous_direct_messages
    conversation_ids = BenchConversation.recent_last_conversation
    return render json: [Current.profile] if conversation_ids.empty?

    @bench_conversations_ids = ConversationMessage.recent_last_conversation(conversation_ids)
    return render json: [Current.profile] if @bench_conversations_ids.empty?

    @dm_users_ids = BenchConversation.where(id: @bench_conversations_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
  end
end
