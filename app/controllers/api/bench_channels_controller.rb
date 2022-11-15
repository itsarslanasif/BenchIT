class Api::BenchChannelsController < Api::ApiController
  def create
    @bench_channel = BenchChannel.new(bench_channel_params)
    return if @bench_channel.save

    render json: { status: false, message: 'There was an error creating the channel.', errors: @bench_channel.errors }
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description).tap do |param|
      param[:creator_id] = current_user.id
    end
  end
end
