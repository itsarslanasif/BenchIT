class Api::V1::DraftMessagesController < Api::ApiController
  include MemberShip

  before_action :fetch_conversation, :initialize_draft, only: %i[create]
  before_action :set_draft_message, :authenticate_draft, only: %i[destroy update]

  def index
    @draft_messages = Current.profile.draft_messages
  end

  def create
    @draft_message.save!
  end

  def update
    if @draft_message.update(draft_messages_params)
      render json: { message: 'Draft updated', draft_message: @draft_message }, status: :updated
    else
      render json: { error: 'Draft not updated', errors: @draft_message.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @draft_message.destroy
      render json: { message: 'Draft deleted successfully.' }, status: :ok
    else
      render json: { error: 'Draft not deleted', errors: @draft_message.errors }, status: :unprocessable_entity
    end
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
      check_membership(@bench_conversation)
    else
      render json: { error: 'Sorry, this draft is not yours' }, status: :unauthorized
    end
  end

  def initialize_draft
    @draft_message = @bench_conversation.draft_messages.new(draft_messages_params)
    check_membership(@bench_conversation)
    return if @bench_conversation.eql?(@draft_message.conversation_message.bench_conversation)

    render json: { error: 'Sorry, this draft is not present in this conversation' },
           status: :unauthorized
  end

  def fetch_conversation
    conversation_id = params[:conversation_id]

    @bench_conversation = case params[:conversation_type]
                          when 'channels'
                            BenchChannel.find_by(id: conversation_id)&.bench_conversation
                          when 'groups'
                            Group.find_by(id: conversation_id)&.bench_conversation
                          when 'profiles'
                            BenchConversation.profile_to_profile_conversation(Current.profile.id, conversation_id)
                          end
    render json: { error: 'wrong type' }, status: :bad_request if @bench_conversation.blank?
  end
end
