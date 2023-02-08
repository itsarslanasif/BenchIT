class Api::V1::PinsController < Api::ApiController
  include MemberShip

  before_action :find_conversation, only: %i[index create]
  before_action :set_pin, only: %i[destroy]
  before_action :authenticate_pin, only: %i[index create destroy]

  def index
    @pins = @conversation.pins
  end

  def create
    @pin = @conversation.pins.new(profile_id: @current_profile.id, conversation_message_id: params[:conversation_message_id])

    @pin.save!
    render json: { success: true, message: 'Pin was successfully created' }, status: :ok
  end

  def destroy
    @pin.destroy!
    render json: { success: true, message: 'Pin was successfully deleted' }, status: :ok
  end

  private

  def find_conversation
    @conversation = if params[:conversation_type].eql?('Profile')
                      BenchConversation.profile_to_profile_conversation(params[:conversation_id], @current_profile.id)
                    else
                      BenchConversation.find_by!(conversationable_type: params[:conversation_type],
                                                 conversationable_id: params[:conversation_id])
                    end
    render json: { error: 'wrong type' }, status: :bad_request if @conversation.blank?
  end

  def set_pin
    @pin = Pin.find(params[:id])
    @conversation = @pin.bench_conversation
  end

  def authenticate_pin
    check_membership(@conversation)
  end
end
