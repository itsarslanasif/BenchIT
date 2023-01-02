class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :set_bench_channel, only: %i[index create]
  before_action :check_channel_participants, only: %i[create]

  def index
    @profiles = if params[:query].presence
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
    params[:profile_ids].map { |profile_id| ChannelParticipant.create(bench_channel_id: @channel.id, profile_id: profile_id, permission: true) }
    render status: :created, json: { members: @users_joined }
  end

  private

  def set_bench_channel
    @channel = BenchChannel.find(params[:bench_channel_id])
  end

  def check_channel_participants
    @channel_members = ChannelParticipant.where(profile_id: params[:profile_ids], bench_channel_id: @channel.id).ids
    return render json: { error: 'One or Many Users already participant of this channel', status: :unprocessable_entity } if @channel_members.present?

    @users_joined = Profile.where(id: params[:profile_ids]).pluck(:username)
  end
end
