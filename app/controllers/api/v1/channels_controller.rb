class Api::V1::ChannelsController < Api::ApiController
  before_action :set_channel, only: [:show, :destroy, :update]
  def index
    current_user = User.first
    render json: current_user.bench_channels
  end

  def show
    current_user = User.first
    if current_user.bench_channel_ids.include?(@channel.id)
      @messages = @channel.bench_conversation.conversation_messages
      message_data = []
      if @messages.empty?
        response = {
          id: 0,
          channel_name: @channel.name,
          content: nil,
          is_threaded: false,
          parent_message_id: nil,
          sender_id: nil,
          sender_name: nil,
          bench_conversation_id: @channel.bench_conversation.id,
          created_at: nil,
          updated_at: nil
        }
        message_data.push(response)
      else
        @messages.each do |message|
          response = {
            id: message.id,
            channel_name: @channel.name,
            content:message.content,
            is_threaded:message.is_threaded,
            parent_message_id:message.parent_message_id,
            sender_id:message.sender_id,
            sender_name:message.user.name,
            bench_conversation_id: message.bench_conversation_id,
            created_at: message.created_at,
            updated_at: message.updated_at
          }
          message_data.push(response)
        end
      end
      render json: message_data
    else
      render json: { json: "no data found", status: :unprocessable_entity }
    end
  end

  def destroy
    if @channel.destroy
      render json: { json: 'Channel was successfully deleted.'}
    else
      render json: { json: @channel.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_channel
    @channel = BenchChannel.find_by_id(params[:id])
    return if @channel.present?
  end

  def bench_channel_params
    params.permit(:name,:description,:creator_id, :is_private)
  end
end
