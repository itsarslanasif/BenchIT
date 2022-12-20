class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :set_bench_channel, only: %i[index create]
  before_action :check_channel_participants, only: %i[create]

  def index
    @profiles = if params[:query].presence
                  Profile.search(
                    params[:query],
                    where: { user_id: @channel.channel_participants.pluck(:user_id) },
                    match: :word_start, misspellings: false
                  )
                else
                  Profile.where(user_id: @channel.channel_participants.select(:user_id)).with_attached_profile_image
                end
  end

  def create
    params[:user_ids].map { |user_id| ChannelParticipant.create(bench_channel_id: @channel.id, user_id: user_id, permission: true) }
    render status: :created, json: { members: @users_joined }
  end

  private

  def set_bench_channel
    @channel = BenchChannel.find(params[:bench_channel_id])
  end

  def check_channel_participants
    @channel_members = ChannelParticipant.where(user_id: params[:user_ids], bench_channel_id: @channel.id).ids
    return render json: { error: 'One or Many Users already participant of this channel', status: :unprocessable_entity } if @channel_members.present?

    @users_joined = User.where(id: params[:user_ids]).pluck(:name)
  end
end
