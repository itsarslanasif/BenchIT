class SearchService
  include Searchkick

  def self.search_records(query, filter)
    models = filter ? [filter.constantize] : [Profile, BenchChannel, ConversationMessage]
    @results = Searchkick.search(query, models: models)
    filter_messages
    @results
  end

  def self.filter_messages
    @results = @results.reject do |result|
      if result.instance_of?(ConversationMessage)
        !check_message(result.bench_conversation)
      elsif result.instance_of?(BenchChannel)
        !check_bench_channel(result)
      elsif result.instance_of?(Profile)
        !check_profile(result)
      end
    end
  end

  def self.check_message(bench_conversation)
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

  def self.check_bench_conversation_workspace(bench_conversation)
    return true if !bench_conversation.conversationable.is_private && bench_conversation.conversationable.workspace.id.eql?(Current.workspace.id)

    false
  end

  def self.check_bench_channel(bench_channel)
    return true if bench_channel.workspace.id.eql?(Current.workspace.id)

    false
  end

  def self.check_profile(profile)
    return true if profile.workspace.id.eql?(Current.workspace.id)

    false
  end
end
