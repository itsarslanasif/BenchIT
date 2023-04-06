module SearchChannels
  extend ActiveSupport::Concern

  def search_channels(params)
    @bench_channels = current_workspace.bench_channels.includes(:profiles)
    search_bench_channels
    filter_bench_channels
    hide_profile_bench_channels
    sort_bench_channels if params[:sort_by].present?
    @bench_channels
  end

  def search_bench_channels
    query = params[:query]
    return if query.blank?

    @bench_channels = BenchChannel.search(query, where: { workspace_id: current_workspace.id },
                                                 match: :word_start)
    @bench_channels = BenchChannel.where(id: @bench_channels.map(&:id))
  end

  def filter_bench_channels
    filter = params[:filter]
    return if filter.blank?

    @bench_channels = case filter
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

  def sort_bench_channels
    sort_methods = ActiveSupport::HashWithIndifferentAccess.new({
                                                                  'newest' => -> { sort_by_bench_channels('created_at', true) },
                                                                  'oldest' => -> { sort_by_bench_channels('created_at', false) },
                                                                  'most_participants' => -> { sort_by_participants(true) },
                                                                  'fewest_participants' => -> { sort_by_participants(false) },
                                                                  'a_to_z' => -> { sort_by_bench_channels('name', false) },
                                                                  'z_to_a' => -> { sort_by_bench_channels('name', true) }
                                                                })
    raise t('.failure') unless sort_methods.key?(params[:sort_by])

    sort_methods[params[:sort_by]].call
  end

  def sort_by_bench_channels(sort_by_param, reverse)
    @bench_channels = @bench_channels.order(sort_by_param => (reverse ? :desc : :asc))
  end

  def sort_by_participants(desc)
    order_keyword = desc ? 'DESC' : 'ASC'
    @bench_channels = @bench_channels.left_joins(:channel_participants).group(:id).order("count(channel_participants) #{order_keyword}")
  end
end
