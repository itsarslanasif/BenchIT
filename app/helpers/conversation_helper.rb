module ConversationHelper
  def get_profile_conversation(profile)
    BenchConversation.profile_to_profile_conversation(Current.profile.id, profile)
  end
end
