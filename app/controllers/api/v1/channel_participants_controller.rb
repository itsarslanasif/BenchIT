class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :set_bench_channel, only: %i[index create mute_channel unmute_channel invite_outsider]
  before_action :set_channel_paticipant, only: %i[mute_channel unmute_channel]
  before_action :check_profile_ids, only: %i[create]
  before_action :pluck_name_of_participants, only: %i[create]
  before_action :set_and_authenticate_channel, only: %i[join_public_channel]

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
        ChannelParticipant.create!(bench_channel_id: @bench_channel.id, profile_id: profile_id, permission: true)
      end
      InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).add_members_in_channel(@users_joined, params[:profile_ids][0])
    end
    render json: { success: true, member_count: @users_joined.count }, status: :ok
  end

  def join_public_channel
    @channel_participant = ChannelParticipant.new(bench_channel_id: @bench_channel.id, profile_id: current_profile.id, permission: true)
    ActiveRecord::Base.transaction do
      @channel_participant.save!
      InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).join_public_channel
    end
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def mute_channel
    @channel_participant.update!(muted: true)
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def unmute_channel
    @channel_participant.update!(muted: false)
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def invite_outsider
    @token = Token.new.generate
    ChannelMailer.send_email(params[:email], @bench_channel, @token).deliver!
    render json: { success: true, message: t('.success'), company_name: @bench_channel.workspace.company_name }, status: :ok
  end

  private

  def set_bench_channel
    @bench_channel = current_profile.bench_channels.find(params[:bench_channel_id])
  end

  def set_channel_paticipant
    @channel_participant = @bench_channel.channel_participants.find_by!(profile_id: current_profile.id)
  end

  def pluck_name_of_participants
    @users_joined = Profile.where(id: params[:profile_ids]).pluck(:username)
  end

  def check_profile_ids
    return if (params[:profile_ids] - current_workspace.profile_ids).blank?

    render json: { success: false, error: t('.failure') }, status: :not_found
  end

  def set_and_authenticate_channel
    @bench_channel = BenchChannel.find(params[:bench_channel_id])
    authorize! :join_public_channel, @bench_channel
  end
end
