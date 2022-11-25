class Api::V1::BenchChannelsController < Api::ApiController
  before_action :set_bench_channel, only: %i[leave]
  before_action :set_channel_participant, only: %i[leave]

  def create
    @bench_channel = BenchChannel.new(bench_channel_params)

    if @bench_channel.save
      create_first_bench_channel_participant
    else
      render json: { status: false, message: 'There was an error creating the channel.', errors: @bench_channel.errors }
    end
  end

  def leave
    @channel_participant.left_on = DateTime.current

    if @channel_participant.save
      @channel_participant.destroy
      render json: { message: "You successfully leaves ##{@bench_channel.name}." }, status: :ok
    else
      render json: { message: 'There was an error.', errors: @channel_participant.errors }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotDestroyed
    render json: { message: 'Database error while destroing.' }, status: :unprocessable_entity
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description)
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
    @channel_participant = ChannelParticipant.find_by(user_id: Current.user.id, bench_channel_id: @bench_channel.id)

    render json: { message: "You are not a member of ##{@bench_channel.name}." }, status: :not_found if @channel_participant.nil?
  end
end
