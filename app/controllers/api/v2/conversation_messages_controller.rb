class Api::V2::ConversationMessagesController < Api::ApiController
  before_action :set_message, only: [:destroy]
  def create
    @message = ConversationMessage.new(conversation_messages_params)
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
    params.permit(:content,:is_threaded,:parent_message_id, :sender_id,:bench_conversation_id)
  end
end












