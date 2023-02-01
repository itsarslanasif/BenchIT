module DraftMessagesHelper
  def any_draft(id)
    DraftMessage.find_by(profile_id: Current.profile.id, bench_conversation_id: id, conversation_message_id: nil)
  end

  def profile_draft(id)
    conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, id)
    any_draft(conversation.id) if conversation.present?
  end
end
