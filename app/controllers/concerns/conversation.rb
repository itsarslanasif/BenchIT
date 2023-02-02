module Conversation
  extend ActiveSupport::Concern

  def get_conversation(conversation_id, conversation_type)
    bench_conversation = case conversation_type
                          when 'channels'
                            BenchChannel.find_by(id: conversation_id)&.bench_conversation
                          when 'groups'
                            Group.find_by(id: conversation_id)&.bench_conversation
                          when 'profiles'
                            BenchConversation.profile_to_profile_conversation(Current.profile.id, conversation_id)
                          end
    render json: { error: 'wrong type' }, status: :bad_request if bench_conversation.blank?
    bench_conversation
  end
end