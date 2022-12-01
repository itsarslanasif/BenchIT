class Api::V1::BenchChannelsController < Api::ApiController
  before_action :set_bench_channel, only: %i[leave show destroy make_private]
  before_action :set_channel_participant, :set_left_on, only: %i[leave]

  def index
    current_user = User.first
    render json: current_user.bench_channels
  end

  def create
    @bench_channel = BenchChannel.new(bench_channel_params)

    if @bench_channel.save
      create_first_bench_channel_participant
    else
      render json: { status: false, message: 'There was an error creating the channel.', errors: @bench_channel.errors }
    end
  end

  def show
    current_user = User.first
    if current_user.bench_channel_ids.include?(@bench_channel.id)
      @messages = @bench_channel.bench_conversation.conversation_messages
      message_data = []
      if @messages.empty?
        response = {
          id: 0,
          channel_name: @bench_channel.name,
          content: nil,
          is_threaded: false,
          parent_message_id: nil,
          sender_id: nil,
          sender_name: nil,
          bench_conversation_id: @bench_channel.bench_conversation.id,
          created_at: nil,
          updated_at: nil
        }
        message_data.push(response)
      else
        @messages.each do |message|
          response = {
            id: message.id,
            channel_name: @bench_channel.name,
            content: message.content,
            is_threaded: message.is_threaded,
            parent_message_id: message.parent_message_id,
            sender_id: message.sender_id,
            sender_name: message.user.name,
            bench_conversation_id: message.bench_conversation_id,
            created_at: message.created_at,
            updated_at: message.updated_at
          }
          message_data.push(response)
        end
      end
      render json: message_data
    else
      render json: { message: 'no data found', status: :unprocessable_entity }
    end
  end

  def destroy
    render json: if @bench_channel.destroy
                   { message: 'Channel was successfully deleted.' }
                 else
                   { message: @bench_channel.errors,
                     status: :unprocessable_entity }
                 end
  end

  def leave
    @channel_participant.destroy

    render json: { message: "You successfully leaves ##{@bench_channel.name}!" }, status: :ok
  rescue ActiveRecord::RecordNotDestroyed
    render json: { message: 'Error while leaving channel!' }, status: :unprocessable_entity
  end

  def make_private
    @bench_channel.is_private = true

    if @bench_channel.save
      render json: {
        message: "Successfully make ##{@bench_channel.name} private. Now, it can only be viewed or joined by invitation."
      }, status: :ok
    else
      render json: { message: 'Error while making channel private!', errors: @bench_channel.errors }, status: :unprocessable_entity
    end
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description, :is_private)
  end

  def create_first_bench_channel_participant
    @bench_channel.channel_participants.create!(bench_channel_id: @bench_channel.id, user_id: current_user.id)
  rescue StandardError
    @bench_channel.destroy

    render json: { status: false, message: 'There was an error creating the channel.' }
  end

  def set_bench_channel
    @bench_channel = BenchChannel.find_by(id: params[:id])

    render json: { message: 'Bench channel not found' }, status: :not_found if @bench_channel.nil?
  end

  def set_channel_participant
    @channel_participant = Current.user.channel_participants.find_by(bench_channel_id: @bench_channel.id)

    render json: { message: "You are not a member of ##{@bench_channel.name}." }, status: :not_found if @channel_participant.nil?
  end

  def set_left_on
    @channel_participant.left_on = DateTime.current

    return if @channel_participant.save

    render json: { message: 'There was an error.', errors: @channel_participant.errors }, status: :unprocessable_entity
  end
end
