class Api::V1::PinsController < Api::ApiController
  before_action :find_conversation, only: %i[index create]
  before_action :set_pin, only: %i[destroy]

  def index
    @pins = @conversation.pins
  end

  def create
    @pin = @conversation.pins.create!(profile_id: Current.profile.id, conversation_message_id: params[:conversation_message_id])

    render json: { message: 'Pin was successfully created' }, status: :ok
  end

  def destroy
    @pin.destroy!

    render json: { message: 'Pin was successfully deleted' }, status: :ok
  end

  private

  def find_conversation
    if params[:conversation_type] == 'Profile'
      @conversation = BenchConversation.profile_to_profile_conversation(params[:conversation_id], Current.profile.id)
      return
    end
    @conversation = BenchConversation.find_by!(conversationable_type: params[:conversation_type], conversationable_id: params[:conversation_id])
  end

  def set_pin
    @pin = Pin.find(params[:id])
  end
end
