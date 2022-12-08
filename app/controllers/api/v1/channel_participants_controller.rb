class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :check_channel_participants, only: %i[create]

  def create
    @channel_participant_users = ChannelParticipant.where(user_id: params[:user_ids], bench_channel_id: @channel_id).pluck(:id)
    if @channel_participant_users.empty?
      params[:user_ids].map {|user|ChannelParticipant.new(bench_channel_id: @channel_id[0], user_id: user,permission: true).save}
      @users_joined = User.where(id: params[:user_ids]).pluck(:name)
      return render status: 201, json: { members: @users_joined }
    else
      render json: { error: "One or Many Users already participant of this channel", status: :unprocessable_entity }
    end
  end

  private

  def channel_participant_params
    params.required(:channel_participant).permit(:bench_channel_name, :user_ids)
  end

  def check_channel_participants
    @channel_id = BenchChannel.where(name: params[:bench_channel_name]).pluck(:id)
    if @channel_id.empty?
      render json: { error: "channel not found", status: :unprocessable_entity }
    end
  end
end
