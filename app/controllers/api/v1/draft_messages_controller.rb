class Api::V1::DraftMessagesController < Api::ApiController
  def index
    @draft_messages = current_user.draft_messages
  end

  def create
    @draft_message = DraftMessage.new(draft_messages_params)
    if @draft_message.save
      render json: { success: 'Draft Message successfully created', draft_message: @draft_message, status: :created }
    else
      render json: { error: @draft_message.errors, status: :unprocessable_entity }
    end
  end

  private

  def draft_messages_params
    params.require(:draft_message).permit(:content, :bench_conversation_id).tap do |param|
      param[:user] = current_user
    end
  end
end
