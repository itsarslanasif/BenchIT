class Api::V1::DraftMessagesController < Api::ApiController
  include Conversation
  include Pagination

  before_action :fetch_conversation, :initialize_draft, :verify_draft, :decide_draft_action, only: %i[create]
  before_action :set_draft_message, :set_conversation, :authenticate_draft, only: %i[destroy update]

  def index
    @pagy, @draft_messages = pagination_for_draft_messages(params[:page])
  end

  def create
    @draft_message.save!
  end

  def update
    @draft_message.update!(draft_messages_params)
    render json: { success: true, message: t('.success'), draft_message: draft_response }, status: :ok
  end

  def destroy
    @draft_message.destroy!
    render json: { success: true, message: t('.success'), draft_message: @draft_message }, status: :ok
  end

  private

  def set_draft_message
    @draft_message = DraftMessage.find(params[:id])
  end

  def set_conversation
    @bench_conversation = @draft_message.bench_conversation
  end

  def draft_messages_params
    params.permit(:content, :bench_conversation_id, :conversation_message_id, message_attachments: []).tap do |param|
      param[:profile] = current_profile
    end
  end

  def initialize_draft
    @draft_message = @bench_conversation.draft_messages.new(draft_messages_params)
  end

  def verify_draft
    authorize! :create, @draft_message
    return if @draft_message.conversation_message_id.blank? || @bench_conversation.eql?(@draft_message.conversation_message.bench_conversation)

    render json: { success: false, message: t('.failure') }, status: :unauthorized
  end

  def decide_draft_action
    message = DraftMessage.get_draft_message(@bench_conversation, params[:conversation_message_id])

    if message.present?
      @draft_message = message
      params[:content].blank? ? destroy : update
    elsif params[:content].blank?
      render json: { success: false, message: t('.failure') }, status: :bad_request
    end
  end

  def fetch_conversation
    @bench_conversation = get_conversation(params[:conversation_id], params[:conversation_type])
  end

  def draft_receiver
    get_receiver(@draft_message.bench_conversation)
  end

  def draft_response
    response = {
      id: @draft_message.id,
      content: @draft_message.content,
      conversation_message_id: @draft_message.conversation_message_id,
      bench_conversation_id: @draft_message.bench_conversation_id,
      profile_id: @draft_message.profile.id,
      conversation_type: @draft_message.bench_conversation.conversationable_type,
      receiver: draft_receiver
    }
    response[:attachments] = get_attachments(@draft_message) if @draft_message.message_attachments.present?
    response
  end

  def authenticate_draft
    if action_name.eql?('update')
      authorize! :update, @draft_message
    else
      authorize! :destroy, @draft_message
    end
  end
end
