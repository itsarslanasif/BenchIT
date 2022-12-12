class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :check_channel_participants, only: %i[create]

  def create
    params[:user_ids].map { |user_id| ChannelParticipant.create(bench_channel_id: @channel_id.id, user_id: user_id, permission: true) }
    render status: :created, json: { members: @users_joined }
  end

  private

  def channel_participant_params
    params.required(:channel_participant).permit(:bench_channel_name, :user_ids)
  end

  def check_channel_participants
    @channel_id = BenchChannel.find_by(name: params[:bench_channel_name])
    render json: { error: 'Channel Not Found', status: :unprocessable_entity } if @channel_id.nil?
    @channel_participants = ChannelParticipant.where(user_id: params[:user_ids], bench_channel_id: @channel_id.id).ids
    render json: { error: 'One or Many Users already participant of this channel', status: :unprocessable_entity } if @channel_participants.present?
    @users_joined = User.where(id: params[:user_ids]).pluck(:name)
  end
end
