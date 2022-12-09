class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :check_channel_participants, only: %i[create]

  def create
    params[:user_ids].map { |user| ChannelParticipant.create(bench_channel_id: @channel_id.id, user_id: user, permission: true) }
    @users_joined = User.where(id: params[:user_ids]).pluck(:name)
    render status: :created, json: { members: @users_joined }
  end

  private

  def channel_participant_params
    params.required(:channel_participant).permit(:bench_channel_name, :user_ids)
  end

  def check_channel_participants
    @channel_id = BenchChannel.find_by(name: params[:bench_channel_name])
    render json: { error: 'channel not found', status: :unprocessable_entity } if @channel_id.nil?
    @channel_participants = ChannelParticipant.where(user_id: params[:user_ids], bench_channel_id: @channel_id.id).ids
    render json: { error: 'One or Many Users already participant of this channel', status: :unprocessable_entity } if @channel_participants.empty?
  end
end
