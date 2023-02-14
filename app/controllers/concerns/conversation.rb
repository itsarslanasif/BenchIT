module Conversation
  extend ActiveSupport::Concern

  def get_conversation(conversation_id, conversation_type)
    conversation = case conversation_type
                   when 'channels'
                     BenchChannel.find_by(id: conversation_id)&.bench_conversation
                   when 'groups'
                     Group.find_by(id: conversation_id)&.bench_conversation
                   when 'profiles'
                     BenchConversation.profile_to_profile_conversation(@current_profile.id, conversation_id)
                   end
    conversation.present? ? conversation : (render json: { success: false, message: I18n.t('concerns.conversation.error') }, status: :bad_request)
  end

  def get_receiver(conversation)
    if conversation.profile? && conversation.conversationable_id.eql?(@current_profile.id)
      conversation.sender
    else
      conversation.conversationable
    end
  end

  def get_attachments(message)
    message.message_attachments.map do |attachment|
      { attachment_link: rails_storage_proxy_url(attachment) }
    end
  end
end
