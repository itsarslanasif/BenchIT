class Api::V1::DraftMessagesController < Api::ApiController
  before_action :set_draft_message, only: %i[update destroy]
  def index
    @draft_messages = current_profile.draft_messages
  end

  def create
    DraftMessage.create!(draft_messages_params)
    render json: { success: true, message: I18n.t('api.v1.draft_messages.create.success') }, status: :ok
  end

  def update
    @draft_message.update!(draft_messages_params)
    render json: { success: true, message: I18n.t('api.v1.draft_messages.update.success') }, status: :ok
  end

  def destroy
    @draft_message.destroy!
    render json: { success: true, message: I18n.t('api.v1.draft_messages.destroy.success') }, status: :ok
  end

  private

  def set_draft_message
    @draft_message = DraftMessage.find(params[:id])
  end

  def draft_messages_params
    params.require(:draft_message).permit(:content, :bench_conversation_id).tap do |param|
      param[:profile] = current_profile
    end
  end
end
