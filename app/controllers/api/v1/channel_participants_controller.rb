class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :set_bench_channel, only: %i[index create join_public_channel]
  before_action :check_channel_participants, only: %i[create]
  before_action :check_workspace, only: %i[join_public_channel]
  before_action :check_already_joined_channel, only: %i[join_public_channel]
  before_action :check_private_channel, only: %i[join_public_channel]

  def index
    @profiles = if params[:query].present?
                  Profile.search(
                    params[:query],
                    where: { id: @channel.channel_participants.pluck(:profile_id) },
                    match: :word_start, misspellings: false
                  )
                else
                  Profile.where(id: @channel.channel_participants.select(:profile_id)).with_attached_profile_image
                end
  end

  def create
    ActiveRecord::Base.transaction do
      params[:profile_ids].map { |profile_id| ChannelParticipant.create(bench_channel_id: @channel.id, profile_id: profile_id, permission: true) }
      InfoMessagesCreatorService.new(@channel.bench_conversation.id).add_members_in_channel(@users_joined, params[:profile_ids][0])
      render status: :created, json: { members: @users_joined }
    end
  end

  def join_public_channel
    @channel_participant = ChannelParticipant.new(bench_channel_id: @channel.id, profile_id: Current.profile.id, permission: true)
    ActiveRecord::Base.transaction do
      if @channel_participant.save
        InfoMessagesCreatorService.new(@channel.bench_conversation.id).join_public_channel(Current.profile.username)
        render json: { success: 'Channel joined successfully', channel: @channel, status: :created }
      else
        render json: { errors: @channel_participant.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_bench_channel
    @channel = BenchChannel.find(params[:bench_channel_id])
  end

  def check_workspace
    return if Current.profile.workspace.eql?(@channel.workspace)

    render json: { error: 'This Channel is not part of your workspace.', status: :unprocessable_entity }
  end

  def check_already_joined_channel
    is_channel_participant = @channel.profile_ids.include?(Current.profile.id)

    render json: { error: 'Already part of this channel.', status: :unprocessable_entity } if is_channel_participant
  end

  def check_private_channel
    return render json: { error: 'You cannot join Private Channel yourself.', status: :unprocessable_entity } if @channel.is_private?
  end

  def check_channel_participants
    @channel_members = ChannelParticipant.where(profile_id: params[:profile_ids], bench_channel_id: @channel.id).ids
    return render json: { error: 'One or Many Users already participant of this channel', status: :unprocessable_entity } if @channel_members.present?

    @users_joined = Profile.where(id: params[:profile_ids]).pluck(:username)
  end
end
