class Api::V1::BenchChannelsController < Api::ApiController
  include Pagination

  before_action :set_bench_channel, only: %i[show update destroy leave_channel]
  before_action :set_channel_participant, :set_left_on, only: :leave_channel
  before_action :bench_channel_cannot_be_public_again, only: :update

  def index
    @bench_channels = current_workspace.bench_channels

    if params[:query].present?
      @bench_channels = BenchChannel.search(params[:query], where: { workspace_id: current_workspace.id },
                                                            match: :word_start)
      @bench_channels = BenchChannel.where(id: @bench_channels.map(&:id))
    end

    filter_bench_channels
    hide_profile_bench_channels
    sort_bench_channels if params[:sort_by].present?
    paginate_bench_channels
  end

  def show; end

  def create
    @bench_channel = BenchChannel.new(bench_channel_params)

    ActiveRecord::Base.transaction do
      if @bench_channel.save
        create_first_bench_channel_participant
      else
        render json: { success: false, error: I18n.t('api.v1.controllers.bench_channels.create.failure') }, status: :unprocessable_entity
      end
    end
  end

  def update
    @bench_channel.update!(bench_channel_params)
    render json: { success: true, message: I18n.t('api.v1.controllers.bench_channels.update.success') }, status: :ok
  end

  def destroy
    @bench_channel.destroy!
    render json: { success: true, message: I18n.t('api.v1.controllers.bench_channels.destroy.success') }, status: :ok
  end

  def leave_channel
    ActiveRecord::Base.transaction do
      if @channel_participant.destroy
        InfoMessagesCreatorService.new(@bench_channel.bench_conversation.id).left_channel(@bench_channel.name)
        render json: { success: true, message: I18n.t('api.v1.controllers.bench_channels.leave_channel.success') }, status: :ok
      else
        render json: { success: false, error: I18n.t('api.v1.controllers.bench_channels.leave_channel.failure') }, status: :unprocessable_entity
      end
    end
  end

  def joined_channels
    @bench_channels = current_profile.bench_channels
  end

  private

  def bench_channel_params
    params.require(:bench_channel).permit(:name, :description, :is_private)
  end

  def create_first_bench_channel_participant
    BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: @bench_channel.id)
    @bench_channel.channel_participants.create!(bench_channel_id: @bench_channel.id, profile_id: current_profile.id)
  end

  def set_bench_channel
    @bench_channel = BenchChannel.includes(:profiles).find(params[:id])
    return if !@bench_channel.is_private || current_profile.bench_channel_ids.include?(@bench_channel.id)

    render json: { success: false, error: I18n.t('api.v1.controllers.bench_channels.set_bench_channel.failure', { bench_channel: @bench_channel.name }) },
           status: :not_found
  end

  def set_channel_participant
    @channel_participant = current_profile.channel_participants.find_by(bench_channel_id: @bench_channel.id)

    return unless @channel_participant.nil?

    render json: { success: false, error: I18n.t('api.v1.controllers.bench_channels.set_channel_participant.failure') }, status: :not_found
  end

  def set_left_on
    @channel_participant.left_on = DateTime.current

    return if @channel_participant.save

    render json: { success: false, error: I18n.t('api.v1.controllers.bench_channels.set_left_on.failure') }, status: :unprocessable_entity
  end

  def bench_channel_cannot_be_public_again
    return unless @bench_channel.is_private? && !params[:bench_channel][:is_private]

    render json: { success: false, error: I18n.t('api.v1.controllers.bench_channels.bench_channel_cannot_be_public_again.failure', { bench_channel: @bench_channel.name }) },
           status: :bad_request
  end

  def sort_bench_channels
    sort_methods = ActiveSupport::HashWithIndifferentAccess.new({
                                                                  'newest' => -> { sort_by_bench_channels('created_at', true) },
                                                                  'oldest' => -> { sort_by_bench_channels('created_at', false) },
                                                                  'most_participants' => -> { sort_by_participants(true) },
                                                                  'fewest_participants' => -> { sort_by_participants(false) },
                                                                  'a_to_z' => -> { sort_by_bench_channels('name', false) },
                                                                  'z_to_a' => -> { sort_by_bench_channels('name', true) }
                                                                })
    raise I18n.t('api.v1.controllers.bench_channels.sort_bench_channels.failure') unless sort_methods.key?(params[:sort_by])

    sort_methods[params[:sort_by]].call
  end

  def filter_bench_channels
    return if params[:filter].blank?

    @bench_channels = case params[:filter]
                      when 'private'
                        @bench_channels.get_private_channels
                      when 'public'
                        @bench_channels.get_public_channels
                      end
  end

  def hide_profile_bench_channels
    @bench_channels = @bench_channels.hide_participated_channels(current_profile.bench_channel_ids) if params[:hide_my_channels].eql?('true')

    @bench_channels = BenchChannel.reject_unjoined_privated_channels(@bench_channels)
  end

  def paginate_bench_channels
    @pagy, @bench_channels = pagination_for_bench_channels(@bench_channels, params[:page] || 1)
  end

  def sort_by_bench_channels(sort_by_param, reverse)
    @bench_channels = @bench_channels.order(sort_by_param => (reverse ? :desc : :asc))
  end

  def sort_by_participants(desc)
    order_keyword = desc ? 'DESC' : 'ASC'
    @bench_channels = @bench_channels.left_joins(:channel_participants).group(:id).order("count(channel_participants) #{order_keyword}")
  end
end
