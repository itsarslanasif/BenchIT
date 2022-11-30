class Api::V1::UsersController < Api::ApiController
  before_action :set_user, only: %i[show]

  def index
    @users = User.all
    render json: @users
  end

  def show
    current_user = User.first
    @conversation = BenchConversation.where(conversationable_type: 'User', sender_id: current_user, conversationable_id: @receiver.id).or(BenchConversation.where(conversationable_type: "User", sender_id: @receiver.id, conversationable_id: current_user)).last
    if @conversation.nil?
      @conversation = BenchConversation.create(conversationable_type: 'User',conversationable_id: @receiver.id, sender_id: current_user.id)
    end
    @messages = @conversation.conversation_messages
    message_data = []
    if @messages.empty?
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

  private

  def set_user
    @receiver = User.find(params[:id])
  end
end
