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

  def get_receiver(message)
    if message.bench_conversation.conversationable_type.eql?('Profile')
      if message.bench_conversation.conversationable_id.eql?(message.profile_id)
        message.bench_conversation.sender
      else
        message.bench_conversation.conversationable
      end
    else
      message.bench_conversation.conversationable
    end
  end

  def get_attachments(message)
    arr = []
    message.message_attachments.each do |attachment|
      arr.push({ attachment_link: rails_storage_proxy_url(attachment) })
    end
    arr
  end
end
