class Api::V1::BenchChannelsController < Api::ApiController
  before_action :set_bench_channel, only: %i[leave show destroy update]
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
      if @messages.empty?
        render status: 200, json: {message: 'chat does not exist',status_code:"1"}
      else
        render "api/v1/bench_channels/show"
      end
    else
      render json: { json: "no data found", status: :unprocessable_entity }
    end
  end

  def destroy
    render json: @bench_channel.destroy ? { message: 'Channel was successfully deleted.'} : { message: @bench_channel.errors, status: :unprocessable_entity }
  end

  def leave
    @channel_participant.destroy

    render json: { message: "You successfully leaves ##{@bench_channel.name}!" }, status: :ok
  rescue ActiveRecord::RecordNotDestroyed
    render json: { message: 'Error while leaving channel!' }, status: :unprocessable_entity
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description, :creator_id, :is_private)
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
