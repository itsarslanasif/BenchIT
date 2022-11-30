class Api::V1::ConversationMessagesController < Api::ApiController
  before_action :fetch_conversation, only: %i[create]
  before_action :set_message, only: %i[destroy]

  def create
    @message = ConversationMessage.new(conversation_messages_params)
    @message.bench_conversation_id = @bench_conversation_id
    if @message.save
      render json: { status: :ok, message: 'Success' }
    else
      render json: { message: @message.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @message.destroy
      render json: { message: 'Message was successfully deleted.'}
    else
      render json: { message: @message.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_message
    @message = ConversationMessage.find_by_id(params[:id])
    return if @message.present?
    render json: { message: @message.errors, status: :unprocessable_entity }
  end

  def conversation_messages_params
    params.permit(:content,:is_threaded,:parent_message_id, :sender_id)
  end

  def fetch_conversation
    type = params[:conversation_type]
    id = params[:conversation_id]
    case type
    when 'channels'
      channel = BenchChannel.find_by_id(id)
      @bench_conversation_id = channel.bench_conversation.id
    when 'groups'
      @bench_conversation_id = Group.find_by_id(id).bench_conversation.id
    when 'users'
      sender_id = params[:sender_id]
      conversation = BenchConversation.user_to_user_conversation(sender_id,id).last
      conversation = BenchConversation.user_to_user_conversation(id,sender_id).last if conversation.nil?
      @bench_conversation_id = conversation.id
    else
      render json: { message: 'wrong type', status: :unprocessable_entity }
    end
  end

end
