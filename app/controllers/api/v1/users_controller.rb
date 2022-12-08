class Api::V1::UsersController < Api::ApiController
  before_action :set_user, only: %i[show]
  before_action :set_previous_direct_messages, only: %i[previous_direct_messages]

  def index
    @users = User.all
    render json: @users
  end

  def show
    current_user = User.first
    @conversation = BenchConversation.user_to_user_conversation(current_user.id, @receiver.id)

    if @conversation.blank?
      @conversation = BenchConversation.create(conversationable_type: 'User', conversationable_id: @receiver.id, sender_id: current_user.id)
    end

    @messages = @conversation.conversation_messages
  end

  def previous_direct_messages
    dm_users_ids = BenchConversation.where(id: @bench_converations_ids).pluck(:conversationable_id, :sender_id).flatten.uniq
    @users = User.where(id: dm_users_ids)
  end

  private

  def set_user
    @receiver = User.find(params[:id])
  end

  def set_previous_direct_messages
    current_user = User.first
    conversation_ids = BenchConversation.last_dm_message
    return render json: { users: [current_user] } if conversation_ids.empty?

    @bench_converations_ids = ConversationMessage.last_dm_message(conversation_ids)
    return render json: { users: [current_user] } if @bench_converations_ids.empty?
  end
end
