class Api::V1::BenchChannelsController < Api::ApiController
  before_action :set_bench_channel, except: %i[index create]
  before_action :set_channel_participant, :set_left_on, only: %i[leave]
  before_action :bench_channel_cannot_be_public_again, only: %i[update]
  before_action :user_already_member, only: %i[join_public_channel]

  def index
    @bench_channel = if params[:query].presence
                       BenchChannel.search(params[:query], where: { workspace_id: Current.workspace.id }, match: :word_start)
                     else
                       BenchChannel.all
                     end
  end

  def show
    @messages = @bench_channel.bench_conversation.conversation_messages
  end

  def create
    @bench_channel = BenchChannel.new(bench_channel_params)

    if @bench_channel.save
      create_first_bench_channel_participant
    else
      render json: { status: false, message: 'There was an error creating the channel.', errors: @bench_channel.errors }
    end
  end

  def update
    return if @bench_channel.update(bench_channel_params)

    render json: { message: 'Error while updating!', errors: @bench_channel.errors }, status: :unprocessable_entity
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

  def join_public_channel
    channel_participant = ChannelParticipant.create(user_id: current_user.id, bench_channel_id: @bench_channel.id)

    render json: { message: "Joined channel successfully ##{@bench_channel.name}!" }, status: :o  k
  rescue ActiveRecord::RecordNotSaved
    render json: { message: 'Could not join channel!', errors: channel_participant.errors }, status: :unprocessable_entity
  end

  def user_already_member
    return if ChannelParticipant.find_or_create_by(user_id: current_user.id, bench_channel_id: @bench_channel.id).nil?

    render json: { message: 'You already joined this channel' }, status: :unprocessable_entity
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
    render json: { json: 'user is not part of this channel', status: :not_found } unless current_user.bench_channel_ids.include?(@bench_channel.id)
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

  def bench_channel_cannot_be_public_again
    return unless @bench_channel.is_private? && !params[:bench_channel][:is_private]

    render json: { message: "You cannot change ##{@bench_channel.name} to public again." }, status: :unprocessable_entity
  end
end
