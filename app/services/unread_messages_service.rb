class UnreadMessagesService
  def initialize(bench_conversation, profile_id, message_id)
    @bench_conversation = bench_conversation
    @profile_id = profile_id
    @message_id = message_id
  end

  def call
    add_in_redis
  end

  private

  def add_in_redis
    previous_unread_messages_details = REDIS.get("unreadMessages#{Current.workspace.id}#{@profile_id}")
    previous_unread_messages_details = previous_unread_messages_details.nil? ? [] : JSON.parse(previous_unread_messages_details)
    previous_unread_messages_details.push({
                                            conversationable_type: @bench_conversation.conversationable_type,
                                            conversationable_id: @bench_conversation.conversationable_id,
                                            message_id: @message_id
                                          })
    return if @profile_id == Current.profile.id

    REDIS.set("unreadMessages#{Current.workspace.id}#{@profile_id}",
              previous_unread_messages_details.to_json)
  end
end
