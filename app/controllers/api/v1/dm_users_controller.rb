class Api::V1::DmUsersController < Api::ApiController
  before_action :set_direct_message_user, only: %i[destroy]
  before_action :set_direct_message_list, only: %i[index]
  before_action :find_last_messages_users, only: %i[last_direct_messages]

  def index
    @profiles = Profile.where(id: @current_profile.dm_users.pluck(:receiver_id) & @direct_message_users_ids)
  end

  def destroy
    if @direct_message_user.destroy
      render json: { message: t('.removed') }, status: :ok
    else
      render json: { errors: @direct_message_user.errors }, status: :unprocessable_entity
    end
  end

  def last_direct_messages
    @last_messages = fetch_last_messages
  end

  def fetch_last_messages
    @last_messages_users.filter_map do |id|
      conversation = BenchConversation.profile_to_profile_conversation(@current_profile.id, id)
      conversation.conversation_messages&.last if conversation.present?
    end.sort_by(&:created_at).reverse
  end

  private

  def set_direct_message_user
    @direct_message_user = @current_profile.dm_users.find_by(receiver_id: params[:id])
    render json: { message: t('.not_found') }, status: :not_found if @direct_message_user.nil?
  end

  def set_direct_message_list
    conversation_ids = BenchConversation.recent_last_conversation
    return render json: [@current_profile] if conversation_ids.empty?

    bench_conversations_ids = ConversationMessage.recent_last_conversation(conversation_ids)
    return render json: [@current_profile] if bench_conversations_ids.empty?

    @direct_message_users_ids = BenchConversation.where(id: bench_conversations_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
  end

  def find_last_messages_users
    conversation_ids = BenchConversation.recent_last_conversation
    return render json: [@current_profile] if conversation_ids.empty?

    @last_messages_users = BenchConversation.where(id: conversation_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
  end
end
