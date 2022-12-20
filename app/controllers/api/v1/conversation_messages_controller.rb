class Api::V1::ConversationMessagesController < Api::ApiController
  before_action :fetch_conversation, only: %i[create]
  before_action :set_message, only: %i[destroy]
  before_action :set_saved_item, only: %i[unsave_message]

  def send_message
    @messages = Current.profile.conversation_messages.includes(:profile).order(created_at: :desc)
  end

  def create
    @message = ConversationMessage.new(conversation_messages_params)
    @message.bench_conversation_id = @bench_conversation.id
    if @message.save
      @message.parent_message.update(is_threaded: true) if @message.parent_message_id.present?
      response = { message: 'Message sent.' }
    else
      response = { message: @message.errors, status: :unprocessable_entity }
    end
    render json: response
  end

  def destroy
    render json: @message.destroy ? { message: 'Message deleted successfully.' } : { message: @message.errors, status: :unprocessable_entity }
  end

  def index_saved_messages
    @saved_items = Current.profile.saved_items
    render 'api/v1/saved_items/index'
  end

  def save_message
    @saved_item = Current.profile.saved_items.new(conversation_message_id: params[:id])

    render json: @saved_item.save ? { json: 'added to saved items' } : @saved_item.errors
  end

  def unsave_message
    render json: @saved_item.destroy ? { json: 'Removed from saved items' } : @saved_item.errors
  end

  def recent_files
    @messages = Current.profile.conversation_messages.with_attached_message_attachments
  end

  private

  def set_saved_item
    @saved_item = Current.profile.saved_items.find_by(conversation_message_id: params[:id])

    return render json: { message: 'Message Not Found.' }, status: :not_found if @saved_item.nil?
  end

  def set_message
    @message = ConversationMessage.find(params[:id])
  end

  def conversation_messages_params
    params.permit(:content, :is_threaded, :parent_message_id, :sender_id, message_attachments: [])
  end

  def fetch_conversation
    conversation_id = params[:conversation_id]

    @bench_conversation = case params[:conversation_type]
                          when 'channels'
                            BenchChannel.find_by(id: conversation_id)&.bench_conversation
                          when 'groups'
                            Group.find_by(id: conversation_id)&.bench_conversation
                          when 'users'
                            BenchConversation.profile_to_profile_conversation(params[:sender_id], conversation_id)
                          end

    render json: { message: 'wrong type', status: :unprocessable_entity } if @bench_conversation.blank?
  end
end
