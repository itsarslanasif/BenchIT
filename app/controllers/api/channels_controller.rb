class Api::ChannelsController < Api::ApiController
  before_action :set_channel, only: [:show]
  def index
    current_user = User.first
    render json: current_user.bench_channels
  end

  private
  def set_channel
    @channel = BenchChannel.find_by_id(params[:id])
    return if @channel.present?
    render json: { json: @channel.errors, status: :unprocessable_entity }
  end
end
