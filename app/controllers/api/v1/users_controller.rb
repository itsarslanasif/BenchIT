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
    render json: {users_ids: dm_users_ids,status_code: 2}
  end

  private

  def set_user
    @receiver = User.find(params[:id])
  end

  def set_previous_direct_messages
    current_user = User.first
    two_weaks_ago_time = Time.now.utc-86800*14
    conversation_ids = BenchConversation.where(conversationable_type: "User", sender_id: current_user).or(BenchConversation.where(conversationable_type: "User", conversationable_id: current_user)).pluck(:id)
    return render json: {message: "No DMs Found",status_code: 1, status: :unprocessable_entity } if conversation_ids.empty?
    @bench_converations_ids = ConversationMessage.where(bench_conversation_id: conversation_ids).where("created_at > ?", two_weaks_ago_time).distinct.pluck(:bench_conversation_id)
    return render json: {message: "No DMs Found in 2 Weaks",status_code: 1, status: :unprocessable_entity } if @bench_converations_ids.empty?
  end
end
