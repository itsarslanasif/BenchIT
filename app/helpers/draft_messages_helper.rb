module DraftMessagesHelper
  def get_draft(id)
    DraftMessage.find_by(profile_id: Current.profile.id, bench_conversation_id: id, conversation_message_id: nil)
  end

  def get_profile_draft(id)
    conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, id)
    get_draft(conversation.id) if conversation.present?
  end
end
