class Api::V1::DraftMessagesController < Api::ApiController
  include MemberShip
  include Conversation

  before_action :fetch_conversation, :initialize_draft, :verify_draft, :decide_draft_action, only: %i[create]
  before_action :set_draft_message, :authenticate_draft, only: %i[destroy update]

  def index
    @draft_messages = Current.profile.draft_messages
  end

  def create
    @draft_message.save!
  end

  def update
    @draft_message.update!(draft_messages_params)
    render json: { success: true, message: 'Draft update' }, status: :ok
  end

  def destroy
    @draft_message.destroy!
    render json: { success: true, message: 'Draft delete' }, status: :ok
  end

  private

  def set_draft_message
    @draft_message = DraftMessage.find(params[:id])
    @bench_conversation = @draft_message.bench_conversation
  end

  def draft_messages_params
    params.require(:draft_message).permit(:content, :bench_conversation_id, :conversation_message_id).tap do |param|
      param[:profile] = Current.profile
    end
  end

  def authenticate_draft
    if @draft_message.profile_id.eql?(Current.profile.id)
      check_membership(@bench_conversatdecide_draft_actionion)
    else
      render json: { error: 'Sorry, this draft is not yours' }, status: :unauthorized
    end
  end

  def decide_draft_action
    @message = DraftMessage.get_draft_message(@bench_conversation, params[:conversation_message_id])
    if params[:content].blank? && @message.present?
      @draft_message = @message
      destroy
    elsif params[:content].present? && @message.present?
      @draft_message = @message
      update
    elsif params[:content].present?
      create
    else
      render json: { error: 'Sorry, the content is empty.' }, status: :bad_request
    end
  end

  def initialize_draft
    @draft_message = @bench_conversation.draft_messages.new(draft_messages_params)
  end

  def verify_draft
    check_membership(@bench_conversation)
    return if @draft_message.conversation_message_id.blank? || @bench_conversation.eql?(@draft_message.conversation_message.bench_conversation)

    render json: { error: 'Sorry, this draft is not present in this conversation' }, status: :unauthorized
  end

  def fetch_conversation
    @bench_conversation = get_conversation(params[:conversation_id], params[:conversation_type])
  end
end
