class UnreadMessagesCreatorService
  def initialize(bench_conversation, profile_ids, message_id)
    @bench_conversation = bench_conversation
    @profile_ids = profile_ids
    @message_id = message_id
  end

  def call
    add_in_redis
  end

  private

  def add_in_redis
    return if @profile_ids.empty?

    @profile_ids.each do |id|
      next if id == Current.profile.id

      previous_unread_messages_details = REDIS.get("unreadMessages#{Current.workspace.id}#{id}")
      previous_unread_messages_details = previous_unread_messages_details.nil? ? {} : JSON.parse(previous_unread_messages_details)
      key = @bench_conversation.conversationable_type + @bench_conversation.conversationable_id.to_s
      key = @bench_conversation.conversationable_type + @bench_conversation.sender_id.to_s if @bench_conversation.conversationable_type.eql?('Profile')
      previous_unread_messages_details[key] ||= []
      previous_unread_messages_details[key] << @message_id

      REDIS.set("unreadMessages#{Current.workspace.id}#{id}", previous_unread_messages_details.to_json)
    end
  end
end
