class Api::V1::ConversationMessagesController < Api::ApiController
  before_action :fetch_conversation, only: %i[create]
  before_action :set_message, only: %i[destroy]

  def create
    @message = ConversationMessage.new(conversation_messages_params)
    @message.bench_conversation_id = @bench_conversation.id
    response = @message.save ? { message: 'Message sent.' } : { message: @message.errors, status: :unprocessable_entity }
    render json: response
  end

  def destroy
    render json: @message.destroy ? { message: 'Message deleted successfully.' } : { message: @message.errors, status: :unprocessable_entity }
  end

  def index_saved_messages
    @saved_items = Current.profile.saved_items
    render "api/v1/saved_items/index"
  end

  def save_message
    @saved_item = Current.profile.saved_items.find_by(conversation_message_id:params[:id])
    if @saved_item
      if @saved_item.destroy
        render json: { json: 'removed from saved items'}
      else
        render json: @saved_item.errors
      end
    else
      @saved_item = Current.profile.saved_items.new(conversation_message_id:params[:id])
      if @saved_item.save
        render json: { json: 'added to saved items'}
      else
        render json: @saved_item.errors
      end
    end
  end

  private

  def set_message
    @message = ConversationMessage.find(params[:id])
  end

  def conversation_messages_params
    params.permit(:content,:is_threaded,:parent_message_id, :sender_id)
  end

  def fetch_conversation
    conversation_id = params[:conversation_id]

    @bench_conversation = case params[:conversation_type]
                          when 'channels'
                            BenchChannel.find_by(id: conversation_id)&.bench_conversation
                          when 'groups'
                            Group.find_by(id: conversation_id)&.bench_conversation
                          when 'users'
                            BenchConversation.user_to_user_conversation(params[:sender_id], conversation_id)
                          end

    render json: { message: 'wrong type', status: :unprocessable_entity } if @bench_conversation.blank?
  end

end
