class Api::V1::BenchChannelsController < Api::ApiController
  before_action :set_bench_channel, except: %i[index create joined_channels]
  before_action :set_channel_participant, :set_left_on, only: %i[leave_channel]
  before_action :bench_channel_cannot_be_public_again, only: %i[update]

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
        render json: { status: false, message: 'There was an error creating the channel.', errors: @bench_channel.errors }
      end
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

  def leave_channel
    ActiveRecord::Base.transaction do
      if @channel_participant.destroy
        InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).left_channel(@bench_channel.name)
        render json: { status: :ok }
      else
        render json: { message: "Unable to leave ##{@bench_channel.name}." }, status: :unprocessable_entity
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
    render json: { json: 'User is not part of channel.', status: :not_found } unless Current.profile.bench_channel_ids.include?(@bench_channel.id)
  end

  def set_channel_participant
    @channel_participant = Current.profile.channel_participants.find_by(bench_channel_id: @bench_channel.id)

    render json: { message: "You are not a member of ##{@bench_channel.name}." }, status: :not_found if @channel_participant.nil?
    @channel = @channel_participant.bench_channel
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
