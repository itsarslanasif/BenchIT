class Api::V1::BenchChannelsController < Api::ApiController
  before_action :set_bench_channel, only: %i[show update destroy leave_channel]
  before_action :set_channel_participant, :set_left_on, only: :leave_channel
  before_action :bench_channel_cannot_be_public_again, only: :update

  def index
    @bench_channels = Current.workspace.bench_channels

    if params[:query].present?
      @bench_channels = BenchChannel.search(params[:query], where: { workspace_id: Current.workspace.id },
                                                            match: :word_start)
    end

    @bench_channels = @bench_channels.reject do |channel|
      channel.is_private && !channel.participant?(Current.profile)
    end
  end

  def show; end

  def create
    @bench_channel = BenchChannel.new(bench_channel_params)

    ActiveRecord::Base.transaction do
      if @bench_channel.save
        create_first_bench_channel_participant
      else
        render json: { error_message: 'There was an error creating the channel.', errors: @bench_channel.errors }, status: :unprocessable_entity
      end
    end
  end

  def update
    return if @bench_channel.update(bench_channel_params)

    render json: { error_message: 'Error while updating!', errors: @bench_channel.errors }, status: :unprocessable_entity
  end

  def destroy
    if @bench_channel.destroy
      render json: { message: 'Channel was successfully deleted.' }, status: :ok
    else
      render json: { error_message: 'Error while deleting', errors: @bench_channel.errors }, status: :unprocessable_entity
    end
  end

  def leave_channel
    ActiveRecord::Base.transaction do
      if @channel_participant.destroy
        InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).left_channel(@bench_channel.name)
        render json: { message: 'Channel left ' }, status: :ok
      else
        render json: { error_message: "Unable to leave ##{@bench_channel.name}." }, status: :unprocessable_entity
      end
    end
  end

  def joined_channels
    @bench_channels = Current.profile.bench_channels
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description, :is_private)
  end

  def create_first_bench_channel_participant
    BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: @bench_channel.id)
    @bench_channel.channel_participants.create!(bench_channel_id: @bench_channel.id, profile_id: Current.profile.id)
  end

  def set_bench_channel
    @bench_channel = BenchChannel.includes(:profiles).find(params[:id])
    return if !@bench_channel.is_private || Current.profile.bench_channel_ids.include?(@bench_channel.id)

    render json: { error_message: 'User is not part of channel.' }, status: :not_found
  end

  def set_channel_participant
    @channel_participant = Current.profile.channel_participants.find_by(bench_channel_id: @bench_channel.id)

    render json: { error_message: "You are not a member of ##{@bench_channel.name}." }, status: :not_found if @channel_participant.nil?
  end

  def set_left_on
    @channel_participant.left_on = DateTime.current

    return if @channel_participant.save

    render json: { error_message: 'There was an error leaving channel.', errors: @channel_participant.errors }, status: :unprocessable_entity
  end

  def bench_channel_cannot_be_public_again
    return unless @bench_channel.is_private? && !params[:bench_channel][:is_private]

    render json: { error_message: "You cannot change ##{@bench_channel.name} to public again." }, status: :bad_request
  end
end
