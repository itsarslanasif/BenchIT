class Api::V1::DraftMessagesController < Api::ApiController
  before_action :set_draft_message, only: %i[update destroy]
  def index
    @draft_messages = Current.profile.draft_messages
  end

  def create
    @draft_message = DraftMessage.new(draft_messages_params)

    if @draft_message.save
      render json: { success: 'Draft Message successfully created', draft_message: @draft_message, status: :created }
    else
      render json: { error: @draft_message.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @draft_message.update(draft_messages_params)
      render json: { success: 'Draft updated', draft_message: @draft_message, status: :updated }
    else
      render json: { errors: @draft_message.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    render json: @draft_message.destroy ? { message: 'Draft deleted successfully.' } : { error: @draft_message.errors, status: :unprocessable_entity }
  end

  private

  def set_draft_message
    @draft_message = DraftMessage.find(params[:id])
  end

  def draft_messages_params
    params.require(:draft_message).permit(:content, :bench_conversation_id).tap do |param|
      param[:profile] = Current.profile
    end
  end
end
