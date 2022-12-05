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
    dm_users_ids = BenchConversation.where(id: @bench_converations_ids).pluck(:conversationable_id,:sender_id).flatten.uniq
    render json: {users_ids: dm_users_ids}
  end

  private

  def set_user
    @receiver = User.find(params[:id])
  end

  def set_previous_direct_messages
    conversation_ids = BenchConversation.set_previous_dms
    if conversation_ids.empty?
      return render json: { message: "No DMs Found", status: :unprocessable_entity }
    else
      @bench_converations_ids = ConversationMessage.set_previous_dms(conversation_ids)
      if @bench_converations_ids.empty?
        return render json: { message: "No DMs Found in 2 Weaks", status: :unprocessable_entity }
      end
    end
  end
end
