class Api::V1::BenchChannelsController < Api::ApiController
  before_action :set_bench_channel, only: %i[leave]
  before_action :set_channel_participant, :set_left_on, only: %i[leave]
  before_action :set_channel, only: %i[join_public_channel]
  before_action :user_already_member, only: %i[join_public_channel]

  def index
    query = params[:term].present? ? params[:term] : nil
    @bench_channel = if query
      render json: BenchChannel.search(query)
    else
      render json: BenchChannel.all
    end
  end

  def create
    @bench_channel = BenchChannel.new(bench_channel_params)

    if @bench_channel.save
      create_first_bench_channel_participant
    else
      render json: { status: false, message: 'There was an error creating the channel.', errors: @bench_channel.errors }
    end
  end

  def join_public_channel
    ChannelParticipant.create(user_id: current_user.id, bench_channel_id: @channel.id)
  end

  def leave
    @channel_participant.destroy

    render json: { message: "You successfully leaves ##{@bench_channel.name}!" }, status: :ok
  rescue ActiveRecord::RecordNotDestroyed
    render json: { message: 'Error while leaving channel!' }, status: :unprocessable_entity
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description)
  end

  def set_channel
    @channel =  BenchChannel.find_by(id: params[:id])
    render json: { message: 'Channel Not Found' }, status: :not_found if @channel.nil?
  end

  def user_already_member

    return if ChannelParticipant.find_by(user_id: current_user.id, bench_channel_id: @channel.id).nil?

    render json: { message: 'You alraedy joined this channel' }, status: :unprocessable_entity
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
