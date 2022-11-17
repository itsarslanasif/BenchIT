class Api::V2::ChannelsController < Api::ApiController
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
      @messages.each do |message|
        response = {
          message_id: message.id,
          content:message.content,
          is_threaded:message.is_threaded,
          parent_message_id:message.parent_message_id,
          sender_id:message.sender_id,
          sender_name:message.user.name,
          conversation_id: message.bench_conversation_id,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
        message_data.push(response)
      end
      render json: message_data
    else
      render json: { json: "no data found", status: :unprocessable_entity }
    end
  end

  def create
    current_user = User.first
    @channel = BenchChannel.new(bench_channel_params)
    if @channel.save
      ChannelParticipant.create(bench_channel_id:@channel.id, user_id:current_user.id)
      BenchConversation.create(conversationable_id:@channel.id, conversationable_type: "BenchChannel")
      render json: { status: :ok, message: 'Success' }
    else
      render json: { json: @channel.errors, status: :unprocessable_entity }
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

    render json: { json: @channel.errors, status: :unprocessable_entity }
  end
  def bench_channel_params
    params.permit(:name,:description,:creator_id, :is_private)
  end
end
