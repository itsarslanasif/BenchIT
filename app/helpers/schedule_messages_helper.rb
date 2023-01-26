module ScheduleMessagesHelper
  def any_scheduled(id)
    ScheduleMessage.where(profile_id: Current.profile.id, bench_conversation_id: id).any?
  end

  def profile_scheduled(id)
    conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, id)
    any_scheduled(conversation.id) if conversation.present?
  end
end
