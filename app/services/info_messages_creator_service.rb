class InfoMessagesCreatorService
  def initialize(bench_conversation_id)
    @bench_conversation_id = bench_conversation_id
    @is_threaded = false
    @sender_id = Current.profile.id
    @is_info = true
  end

  def join_public_channel
    ConversationMessage.create(
      content: 'joined this channel.',
      is_threaded: @is_threaded,
      bench_conversation_id: @bench_conversation_id,
      sender_id: @sender_id,
      is_info: @is_info
    )
  end

  def add_members_in_channel(users_joined, first_member_id)
    remaining_users = users_joined.reject { |user| user.eql?(users_joined[0]) }
    ConversationMessage.create(
      content: "added by #{Current.profile.username}#{remaining_users.empty? ? '.' : " along with #{remaining_users.join(', ')}."}",
      is_threaded: @is_threaded,
      bench_conversation_id: @bench_conversation_id,
      sender_id: first_member_id,
      is_info: @is_info
    )
  end

  def left_channel(channel_name)
    ConversationMessage.create(
      content: "left ##{channel_name}.",
      is_threaded: @is_threaded,
      bench_conversation_id: @bench_conversation_id,
      sender_id: @sender_id,
      is_info: @is_info
    )
  end
end
