class Api::V1::UsersController < Api::ApiController
  before_action :set_user, only: %i[show]
  before_action :set_previous_direct_messages, only: %i[previous_direct_messages]

  def index
    @users = Profile.where(workspace_id: current_profile.workspace_id)
    render json: @users
  end

  def show
    @conversation = BenchConversation.user_to_user_conversation(current_profile.id, @receiver.id)

    if @conversation.blank?
      @conversation = BenchConversation.create(conversationable_type: 'Profile', conversationable_id: @receiver.id, sender_id: current_profile.id)
    end

    @messages = @conversation.conversation_messages.includes(:profile, :reactions).with_attached_message_attachments
  end

  def previous_direct_messages
    dm_users_ids = BenchConversation.where(id: @bench_converations_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
    @users = Profile.where(id: dm_users_ids)
  end

  private

  def set_user
    @receiver = Profile.find(params[:id])
  end

  def set_previous_direct_messages
    conversation_ids = BenchConversation.last_dm_message
    return render json: [Current.profile] if conversation_ids.empty?

    @bench_converations_ids = ConversationMessage.last_dm_message(conversation_ids)
    return render json: [Current.profile] if @bench_converations_ids.empty?
  end
end
