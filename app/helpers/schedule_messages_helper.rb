module ScheduleMessagesHelper
  def scheduled?(id)
    ScheduleMessage.exists?(profile_id: Current.profile.id, bench_conversation_id: id)
  end

  def schedule_profile(id)
    conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, id)
    scheduled?(conversation.id) if conversation.present?
  end
end
