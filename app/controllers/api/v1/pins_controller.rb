class Api::V1::PinsController < Api::ApiController
  include MemberShip
  include Conversation

  before_action :find_conversation, only: %i[index create]
  before_action :set_pin, only: %i[destroy]
  before_action :authenticate_pin, only: %i[index]

  def index
    @pins = @conversation.pins
  end

  def create
    @pin = @conversation.pins.new(profile_id: current_profile.id, conversation_message_id: pin_params[:conversation_message_id])
    authorize! :create, @pin
    @pin.save!
    render json: { success: true, message: t('.create.success') }, status: :ok
  end

  def destroy
    @pin.destroy!
    render json: { success: true, message: t('.destroy.success') }, status: :ok
  end

  private

  def find_conversation
    @conversation = if pin_params[:conversation_id].present? && pin_params[:conversation_type].present?
                      get_conversation(params[:conversation_id], params[:conversation_type])
                    else
                      BenchConversation.find(pin_params[:bench_conversation_id])
                    end
  end

  def pin_params
    params.permit(:conversation_id, :conversation_type, :bench_conversation_id, :conversation_message_id)
  end

  def set_pin
    @pin = Pin.find(params[:id])
    @conversation = @pin.bench_conversation
    authorize! :destroy, @pin
  end

  def authenticate_pin
    check_membership(@conversation)
  end
end
