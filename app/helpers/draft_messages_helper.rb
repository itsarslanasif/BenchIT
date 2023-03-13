module DraftMessagesHelper
  def get_draft(id, message_id = nil)
    DraftMessage.find_by(profile_id: Current.profile.id, bench_conversation_id: id, conversation_message_id: message_id)
  end

  def get_profile_draft(id)
    conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, id)
    get_draft(conversation.id) if conversation.present?
  end
end
