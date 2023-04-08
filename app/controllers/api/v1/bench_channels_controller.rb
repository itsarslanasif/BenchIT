class Api::V1::BenchChannelsController < Api::ApiController
  include Pagination
  include CanAuthorization
  include SearchChannels

  before_action :set_bench_channel, :authenticate_channel, only: %i[show update destroy leave_channel]
  before_action :set_channel_participant, only: :leave_channel
  before_action :bench_channel_cannot_be_public_again, only: :update

  def index
    @bench_channels = search_channels(search_channel_params)
    paginate_bench_channels
  end

  def show; end

  def create
    @bench_channel = BenchChannel.new(bench_channel_params)
    ActiveRecord::Base.transaction do
      @bench_channel.save!
      create_first_bench_channel_participant
    end
  end

  def update
    authorize! :update_name, @bench_channel if params[:bench_channel][:name] != @bench_channel.name
    @bench_channel.update!(bench_channel_params)
    if @bench_channel.saved_change_to_description?
      InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).edit_channel(@bench_channel.description)
    end
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def destroy
    @bench_channel.destroy!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def leave_channel
    ActiveRecord::Base.transaction do
      @channel_participant.destroy!
      InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).left_channel(@bench_channel.name)
    end
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def joined_channels
    @bench_channels = current_profile.bench_channels
  end

  private

  def search_channel_params
    params.permit(:query, :filter, :hide_my_channels, :sort_by, :page)
  end

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description, :is_private)
  end

  def create_first_bench_channel_participant
    BenchConversation.create!(conversationable: @bench_channel)
    @bench_channel.channel_participants.create!(profile_id: current_profile.id)
  end

  def set_bench_channel
    @bench_channel = BenchChannel.includes(:profiles).find(params[:id])
  end

  def set_channel_participant
    @channel_participant = current_profile.channel_participants.find_by!(bench_channel_id: @bench_channel.id)
    authorize! :leave_channel, @channel_participant
  end

  def bench_channel_cannot_be_public_again
    return unless @bench_channel.is_private? && !params[:bench_channel][:is_private]

    render json: { success: false, error: t('.failure') }, status: :bad_request
  end

  def paginate_bench_channels
    @pagy, @bench_channels = pagination_for_bench_channels(@bench_channels, search_channel_params[:page] || 1)
  end

  def authenticate_channel
    authorize_action(action_name, @bench_channel) unless action_name.eql?('leave_channel')
  end
end
