class Api::V2::UsersController < Api::ApiController
  before_action :set_user, only: [:show]
  def index
    @users = User.all
    render json: @users
  end
  def show
    current_user = User.first
    @conversation = BenchConversation.where(conversationable_type: "User", sender_id: current_user, conversationable_id: @receiver.id).or(BenchConversation.where(conversationable_type: "User", sender_id: @receiver.id, conversationable_id: current_user)).last
    if @conversation.nil?
      @conversation = BenchConversation.create(conversationable_type: "User",conversationable_id: @receiver.id, sender_id: current_user)
    end
    @messages = @conversation.conversation_messages
    message_data = []
    @messages.each do |message|
      response = {
        message_id: message.id,
        content:message.content,
        is_threaded:message.is_threaded,
        parent_message_id:message.parent_message_id,
        sender_id:message.sender_id,
        sender_name:message.user.name,
        conversation_id: message.bench_conversation_id,
        created_at: message.created_at,
        updated_at: message.updated_at
      }
      message_data.push(response)
    end
    render json: message_data
  end
  private
  def set_user
    @receiver = User.find_by_id(params[:id])
    return if @receiver.present?
    render json: { json: @receiver.errors, status: :unprocessable_entity }
  end
end
