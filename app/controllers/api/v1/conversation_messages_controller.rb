class Api::V1::ConversationMessagesController < Api::ApiController
  before_action :fetch_conversation, only: [:create]
  before_action :set_message, only: [:destroy]

  def create
    @message = ConversationMessage.new(conversation_messages_params)
    @message.bench_conversation_id = @bench_conversation_id
    if @message.save
      render json: { status: :ok, message: 'Success' }
    else
      render json: { json: @message.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @message.destroy
      render json: { json: 'Message was successfully deleted.'}
    else
      render json: { json: @message.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_message
    @message = ConversationMessage.find_by_id(params[:id])
    return if @message.present?
    render json: { json: @message.errors, status: :unprocessable_entity }
  end

  def conversation_messages_params
    params.permit(:content,:is_threaded,:parent_message_id, :sender_id)
  end

  def fetch_conversation
    type = params[:conversation_type]
    id = params[:conversation_id]
    if type == "channels"
      channel = BenchChannel.find_by_id(id)
      @bench_conversation_id = channel.bench_conversation.id
    elsif type == "groups"
      @bench_conversation_id = Group.find_by_id(id).bench_conversation.id
    elsif type == "users"
      sender_id = params[:sender_id]
      conversation = BenchConversation.user_to_user_conversation(sender_id,id).last
      if conversation.nil?
        conversation = BenchConversation.user_to_user_conversation(id,sender_id).last
      end
      @bench_conversation_id = conversation.id
    else
      render json: { json: "wrong type", status: :unprocessable_entity }
    end
  end

end
