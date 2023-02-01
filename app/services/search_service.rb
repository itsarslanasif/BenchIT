class SearchService
  include Searchkick

  def initialize(query, filter)
    @query = query
    @filter = filter.eql?('null') ? nil : filter
  end

  def call
    search_records
  end

  private

  def search_records
    models = @filter ? [@filter.constantize] : [Profile, BenchChannel, ConversationMessage]
    @results = Searchkick.search(@query, models: models)
    filter_messages
  end

  def filter_messages
    @results = @results.reject do |result|
      if result.instance_of?(ConversationMessage)
        !check_message(result.bench_conversation)
      elsif result.instance_of?(BenchChannel)
        !check_bench_channel(result) || check_bench_channel_participant(result)
      elsif result.instance_of?(Profile)
        !check_profile(result)
      end
    end
  end

  def check_message(bench_conversation)
    profile_ids = case bench_conversation.conversationable_type
                  when 'Profile'
                    if bench_conversation.sender.workspace_id.eql?(Current.workspace.id)
                      [bench_conversation.conversationable_id,
                       bench_conversation.sender_id]
                    end
                  when 'BenchChannel', 'Group'
                    if bench_conversation.conversationable_type.eql?('BenchChannel') && check_bench_conversation_workspace(bench_conversation)
                      [Current.profile.id]
                    else
                      bench_conversation.conversationable.profile_ids
                    end
                  end
    profile_ids.present? && profile_ids.include?(Current.profile.id)
  end

  def check_bench_conversation_workspace(bench_conversation)
    !bench_conversation.conversationable.is_private && bench_conversation.conversationable.workspace.id.eql?(Current.workspace.id)
  end

  def check_bench_channel(bench_channel)
    bench_channel.workspace.id.eql?(Current.workspace.id)
  end

  def check_bench_channel_participant(bench_channel)
    bench_channel.is_private && !bench_channel.participant?(Current.profile)
  end

  def check_profile(profile)
    profile.workspace.id.eql?(Current.workspace.id)
  end
end
