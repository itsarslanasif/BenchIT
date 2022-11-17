class Api::BenchChannelsController < Api::ApiController
  def create
    @bench_channel = BenchChannel.new(bench_channel_params)
    if @bench_channel.save
      create_first_bench_channel_participant
    else
      render json: { status: false, message: 'There was an error creating the channel.', errors: @bench_channel.errors }
    end
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description).tap do |param|
      param[:creator_id] = current_user.id
      params[:workspace_id] = session[:cuurent_workspace_id]
    end
  end

  def create_first_bench_channel_participant
    @bench_channel.channel_participants.create!(bench_channel_id: @bench_channel.id, user_id: current_user.id)
  rescue StandardError
    @bench_channel.destroy
    render json: { status: false, message: 'There was an error creating the channel.' }
  end
end
