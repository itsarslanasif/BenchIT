class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :set_bench_channel, only: %i[index create join_public_channel mute_channel unmute_channel]
  before_action :set_channel_paticipant, only: %i[mute_channel unmute_channel]
  before_action :check_profile_ids, only: %i[create]
  before_action :check_channel_participants, only: %i[create]
  before_action :check_workspace, only: %i[join_public_channel]
  before_action :check_already_joined_channel, only: %i[join_public_channel]
  before_action :check_private_channel, only: %i[join_public_channel]

  def index
    @profiles = if params[:query].present?
                  Profile.search(
                    params[:query],
                    where: { id: @bench_channel.channel_participants.pluck(:profile_id) },
                    match: :word_start, misspellings: false
                  )
                else
                  Profile.where(id: @bench_channel.channel_participants.select(:profile_id)).with_attached_profile_image
                end
  end

  def create
    ActiveRecord::Base.transaction do
      params[:profile_ids].each do |profile_id|
        ChannelParticipant.create(bench_channel_id: @bench_channel.id, profile_id: profile_id, permission: true)
      end

      InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).add_members_in_channel(@users_joined, params[:profile_ids][0])
      render json: { member_count: @users_joined.count }, status: :ok
    end
  end

  def join_public_channel
    @channel_participant = ChannelParticipant.new(bench_channel_id: @bench_channel.id, profile_id: Current.profile.id, permission: true)
    ActiveRecord::Base.transaction do
      if @channel_participant.save
        InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).join_public_channel
        render json: { message: "Joined ##{@bench_channel.name}." }, status: :ok
      else
        render json: { error: "Unable to join ##{@bench_channel.name}.", errors: @channel_participant.errors }, status: :unprocessable_entity
      end
    end
  end

  def mute_channel
    if @channel_participant.update(muted: true)
      render json: { message: t('channel_participants.channel_muted') }, status: :ok
    else
      render json: { errors: @channel_participant.errors }, status: :unprocessable_entity
    end
  end

  def unmute_channel
    if @channel_participant.update(muted: false)
      render json: { message: t('channel_participants.channel_unmuted') }, status: :ok
    else
      render json: { errors: @channel_participant.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_bench_channel
    @bench_channel = BenchChannel.find(params[:bench_channel_id])
    return if !@bench_channel.is_private || Current.profile.bench_channel_ids.include?(@bench_channel.id)

    render json: { errors: 'User is not part of channel.' }, status: :not_found
  end

  def set_channel_paticipant
    @channel_participant = ChannelParticipant.where(bench_channel_id: @bench_channel.id, profile_id: Current.profile.id)
  end

  def check_workspace
    return if Current.profile.workspace.eql?(@bench_channel.workspace)

    render json: { error: 'This Channel is not part of your workspace.' }, status: :forbidden
  end

  def check_already_joined_channel
    is_channel_participant = @bench_channel.profile_ids.include?(Current.profile.id)

    render json: { error: 'User already part of this channel.' }, status: :unprocessable_entity if is_channel_participant
  end

  def check_private_channel
    return render json: { error: 'You cannot join Private Channel yourself.' }, status: :forbidden if @bench_channel.is_private?
  end

  def check_channel_participants
    @channel_members = ChannelParticipant.where(profile_id: params[:profile_ids], bench_channel_id: @bench_channel.id).ids
    return render json: { error: 'One or Many Users already participant of this channel' }, status: :forbidden if @channel_members.present?

    @users_joined = Profile.where(id: params[:profile_ids]).pluck(:username)
  end

  def check_profile_ids
    return if (params[:profile_ids] - Current.workspace.profile_ids).blank?

    render json: { error: 'Profiles cannot be found' }, status: :not_found
  end
end
