json.extract! message, :id, :content, :conversation_message_id, :bench_conversation_id, :profile_id, :created_at
json.partial! 'api/v1/shared/partials/message_receiver', message: message
json.conversation_type message.bench_conversation.conversationable_type
if message.message_attachments.present?
  json.attachments message.message_attachments do |attachment|
    json.attachment_link rails_storage_proxy_url(attachment)
  end
end
