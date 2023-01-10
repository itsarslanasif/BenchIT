class UnreadMessagesDestroyerService
  def initialize(bench_conversation)
    @bench_conversation = bench_conversation
  end

  def call
    remove_from_redis
  end

  private

  def generate_key
    if @bench_conversation.conversationable_type.eql?('Profile')
      if @bench_conversation.sender_id.eql?(Current.profile.id)
        @bench_conversation.conversationable_type + @bench_conversation.conversationable_id.to_s
      else
        @bench_conversation.conversationable_type + @bench_conversation.sender_id.to_s
      end
    else
      @bench_conversation.conversationable_type + @bench_conversation.conversationable_id.to_s
    end
  end

  def remove_from_redis
    previous_unread_messages_details = REDIS.get("unreadMessages#{Current.workspace.id}#{Current.profile.id}")
    previous_unread_messages_details = previous_unread_messages_details.nil? ? {} : JSON.parse(previous_unread_messages_details)

    key = generate_key
    previous_unread_messages_details[key] = []

    REDIS.set("unreadMessages#{Current.workspace.id}#{Current.profile.id}", previous_unread_messages_details.to_json)
  end
end
