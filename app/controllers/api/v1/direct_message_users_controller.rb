class Api::V1::DirectMessageUsersController < Api::ApiController
  before_action :set_receiver, only: %i[destroy]
  before_action :set_direct_message_list, only: %i[index]
  before_action :set_recent_message_users, only: %i[recent_direct_messages]

  def index
    @profiles = DirectMessageUser.dm_profiles(@direct_message_users_ids)
  end

  def destroy
    @direct_message_user.destroy!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def recent_direct_messages
    @recent_messages = fetch_recent_messages
  end

  private

  def set_receiver
    @direct_message_user = current_profile.direct_message_users.find_by(receiver_id: params[:id])
    render json: { success: false, message: t('.failure') }, status: :not_found if @direct_message_user.nil?
  end

  def set_direct_message_list
    conversation_ids = BenchConversation.recent_conversation_ids
    bench_conversations_ids = ConversationMessage.recent_conversation_ids(conversation_ids)

    return render template: 'api/v1/direct_message_users/index', locals: { profile: [current_profile] } if bench_conversations_ids.empty?

    @direct_message_users_ids = BenchConversation.where(id: bench_conversations_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
  end

  def set_recent_message_users
    conversation_ids = BenchConversation.recent_conversation_ids
    @recent_messages_users = BenchConversation.where(id: conversation_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
  end

  def fetch_recent_messages
    @recent_messages_users.filter_map do |id|
      conversation = BenchConversation.profile_to_profile_conversation(current_profile.id, id)
      conversation.conversation_messages&.last if conversation.present?
    end.sort_by(&:created_at).reverse
  end
end
