class Api::V1::BenchConversationsController < Api::ApiController
  include CanAuthorization
  before_action :find_conversation, :authenticate_conversation, only: %i[update]

  def update
    @bench_conversation.update!(bench_conversation_params)
    InfoMessagesCreatorService.new(@bench_conversation.id).edit_topic(@bench_conversation.topic)
    render json: { success: true, message: t('.success') }, status: :ok
  end

  private

  def bench_conversation_params
    params.require(:bench_conversation).permit(:topic)
  end

  def find_conversation
    @bench_conversation = BenchConversation.find(params[:id])
  end

  def authenticate_conversation
    authorize_action(action_name, @bench_conversation)
  end
end
