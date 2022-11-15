class Api::ChannelsController < Api::ApiController
  before_action :set_channel, only: [:show]
  def index
    current_user = User.first
    @participants = current_user.channel_participants.pluck(:bench_channel_id)
    @channels = BenchChannel.where(id:@participants)
    render json: @channels
  end

  private
  def set_channel
    @channel = BenchChannel.find_by_id(params[:id])
    return if @channel.present?

    render json: { json: @channel.errors, status: :unprocessable_entity }
  end
end
