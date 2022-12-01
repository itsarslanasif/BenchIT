class Api::V1::UsersController < Api::ApiController
  before_action :set_user, only: %i[show]

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
    message_data = []
    if @messages.blank?
      response = {
        id: 0,
        receiver_name: @receiver.name,
        content: nil,
        is_threaded: false,
        parent_message_id: nil,
        sender_id: nil,
        sender_name: nil,
        bench_conversation_id: @conversation.id,
        created_at: nil,
        updated_at: nil
      }
      message_data.push(response)
    else
      @messages.each do |message|
        response = {
          id: message.id,
          receiver_name: @receiver.name,
          content:message.content,
          is_threaded:message.is_threaded,
          parent_message_id:message.parent_message_id,
          sender_id:message.sender_id,
          sender_name:message.user.name,
          bench_conversation_id: message.bench_conversation_id,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
        message_data.push(response)
      end
    end
    render json: message_data
  end

  def previous_direct_messages
    two_weaks_ago_time=Time.now.utc-86800*14
    current_user=User.find(params[:id])
    converation_ids = BenchConversation.where(conversationable_type: "User", sender_id: current_user).or(BenchConversation.where(conversationable_type: "User", conversationable_id: current_user)).pluck(:id)
    if converation_ids.empty?
      return render json: {message: "No DMs Found",status_code: 1, status: :unprocessable_entity }
    else
      bench_converations_ids=ConversationMessage.where(bench_conversation_id: converation_ids).where("created_at > ?", two_weaks_ago_time).distinct.pluck(:bench_conversation_id)
      if bench_converations_ids.empty?
        return render json: {message: "No DMs Found in 2 Weaks",status_code: 1, status: :unprocessable_entity }
      else
        dm_users_ids=BenchConversation.where(id: bench_converations_ids).pluck(:conversationable_id,:sender_id).flatten.uniq
        render json: {users_ids: dm_users_ids,status_code: 2}
      end
    end
  end

  private

  def set_user
    @receiver = User.find(params[:id])
  end
end
