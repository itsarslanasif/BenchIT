module ConversationHelper
  def get_profile_conversation_id(profile)
    BenchConversation.profile_to_profile_conversation(Current.profile.id, profile)&.id
  end
end
