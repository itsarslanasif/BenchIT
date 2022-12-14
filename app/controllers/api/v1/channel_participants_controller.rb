class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :check_channel_participants, only: %i[create]

  def index
    @profiles = if params[:query].presence
                  Profile.search(
                    params[:query],
                    where: { user_id: BenchChannel.find(params[:bench_channel_id]).channel_participants.pluck(:user_id) },
                    match: :word_start, misspellings: false
                  )
                else
                  Profile.where(user_id: BenchChannel.find(params[:bench_channel_id]).channel_participants.select(:user_id))
                end
  end

  def create
    params[:user_ids].map { |user_id| ChannelParticipant.create(bench_channel_id: @channel_id.id, user_id: user_id, permission: true) }
    render status: :created, json: { members: @users_joined }
  end

  private

  def channel_participant_params
    params.required(:channel_participant).permit(:bench_channel_id, :user_ids, :query)
  end

  def check_channel_participants
    @channel_id = BenchChannel.find_by(id: params[:bench_channel_id])
    return render json: { error: 'Channel Not Found', status: :unprocessable_entity } if @channel_id.nil?

    @channel_members = ChannelParticipant.where(user_id: params[:user_ids], bench_channel_id: @channel_id.id).ids
    return render json: { error: 'One or Many Users already participant of this channel', status: :unprocessable_entity } if @channel_members.present?

    @users_joined = User.where(id: params[:user_ids]).pluck(:name)
  end
end
