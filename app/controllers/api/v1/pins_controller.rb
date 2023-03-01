class Api::V1::PinsController < Api::ApiController
  include MemberShip
  include Conversation
  include CanAuthorization

  before_action :find_conversation, only: %i[index create]
  before_action :set_pin, :set_conversation, only: %i[destroy]
  before_action :initialize_pin, only: %i[create]
  before_action :authenticate_pin, only: %i[index create destroy]

  def index
    @pins = @conversation.pins
  end

  def create
    @pin.save!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def destroy
    @pin.destroy!
    render json: { success: true, message: t('.success') }, status: :ok
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
  end

  def set_conversation
    @conversation = @pin.bench_conversation
  end

  def initialize_pin
    @pin = @conversation.pins.new(profile_id: current_profile.id, conversation_message_id: pin_params[:conversation_message_id])
  end

  def authenticate_pin
    action_name.eql?('index') ? check_membership(@conversation) : authorize_action(action_name, @pin)
  end
end
