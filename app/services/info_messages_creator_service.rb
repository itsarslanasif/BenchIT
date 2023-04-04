class InfoMessagesCreatorService
  def initialize(bench_conversation_id)
    @bench_conversation_id = bench_conversation_id
    @is_threaded = false
    @sender_id = Current.profile.id
    @is_info = true
  end

  def join_public_channel
    ConversationMessage.create(
      content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"#{I18n.t('application.services.join_message')}"}}]}),
      is_threaded: @is_threaded,
      bench_conversation_id: @bench_conversation_id,
      sender_id: @sender_id,
      is_info: @is_info
    )
  end

  def add_members_in_channel(users_joined, first_member_id)
    users = users_joined.reject { |user| user.eql?(users_joined[0]) }
    ConversationMessage.create(
      content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"added by #{Current.profile.username}#{user_list(users)}"}}]}),
      is_threaded: @is_threaded,
      bench_conversation_id: @bench_conversation_id,
      sender_id: first_member_id,
      is_info: @is_info
    )
  end

  def left_channel(channel_name)
    ConversationMessage.create(
      content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"#{I18n.t('application.services.left_message')} #{channel_name}"}}]}),
      is_threaded: @is_threaded,
      bench_conversation_id: @bench_conversation_id,
      sender_id: @sender_id,
      is_info: @is_info
    )
  end

  def edit_topic(topic)
    text = topic.blank? ? 'cleared the conversation topic' : "set the conversation topic: #{topic}"
    ConversationMessage.create(
      content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"#{text}"}}]}),
      is_threaded: @is_threaded,
      bench_conversation_id: @bench_conversation_id,
      sender_id: @sender_id,
      is_info: @is_info
    )
  end

  private

  def user_list(users)
    users.empty? ? '.' : " along with #{users.join(', ')}"
  end
end
