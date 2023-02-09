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
    @channel_participant = ChannelParticipant.new(bench_channel_id: @bench_channel.id, profile_id: current_profile.id, permission: true)
    ActiveRecord::Base.transaction do
      if @channel_participant.save
        InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).join_public_channel
        render json: { success: true, message: I18n.t('api.v1.controllers.channel_participants.join_public_channel.success', { channel_name: @bench_channel.name }) },
               status: :ok
      else
        render json: { success: false, error: I18n.t('api.v1.controllers.channel_participants.join_public_channel.failure', { channel_name: @bench_channel.name }) },
               status: :unprocessable_entity
      end
    end
  end

  def mute_channel
    @channel_participant.update!(muted: true)
    render json: { success: true, message: I18n.t('api.v1.controllers.channel_participants.mute_channel.success') }, status: :ok
  end

  def unmute_channel
    @channel_participant.update!(muted: false)
    render json: { success: true, message: I18n.t('api.v1.controllers.channel_participants.unmute_channel.success') }, status: :ok
  end

  private

  def set_bench_channel
    @bench_channel = BenchChannel.find(params[:bench_channel_id])
    return if !@bench_channel.is_private || current_profile.bench_channel_ids.include?(@bench_channel.id)

    render json: { success: false, error: I18n.t('api.v1.controllers.channel_participants.set_bench_channel.failure') }, status: :not_found
  end

  def set_channel_paticipant
    @channel_participant = ChannelParticipant.where(bench_channel_id: @bench_channel.id, profile_id: current_profile.id)
  end

  def check_workspace
    return if current_profile.workspace.eql?(@bench_channel.workspace)

    render json: { success: false, error: I18n.t('api.v1.controllers.channel_participants.check_workspace.failure') }, status: :forbidden
  end

  def check_already_joined_channel
    is_channel_participant = @bench_channel.profile_ids.include?(current_profile.id)

    return unless is_channel_participant

    render json: { success: false, error: I18n.t('api.v1.controllers.channel_participants.check_already_joined_channel.failure') },
           status: :unprocessable_entity
  end

  def check_private_channel
    return unless @bench_channel.is_private?

    render json: { success: false, error: I18n.t('api.v1.controllers.channel_participants.check_private_channel.failure') },
           status: :forbidden
  end

  def check_channel_participants
    @channel_members = ChannelParticipant.where(profile_id: params[:profile_ids], bench_channel_id: @bench_channel.id).ids
    if @channel_members.present?
      return render json: { success: false, error: I18n.t('api.v1.controllers.channel_participants.check_channel_participants.failure') },
                    status: :forbidden
    end

    @users_joined = Profile.where(id: params[:profile_ids]).pluck(:username)
  end

  def check_profile_ids
    return if (params[:profile_ids] - current_workspace.profile_ids).blank?

    render json: { success: false, error: I18n.t('api.v1.controllers.channel_participants.check_profile_ids.failure') }, status: :not_found
  end
end
