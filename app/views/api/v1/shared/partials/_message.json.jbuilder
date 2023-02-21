json.extract! message, :id, :content, :is_threaded, :parent_message_id, :sender_id, :created_at, :updated_at, :is_info, :is_sent_to_chat
json.sender_name message.profile.username
json.partial! 'api/v1/reactions/partials/reactions', reactions: message.reactions
json.sender_avatar url_for(message.profile.profile_image) if message.profile.profile_image.attached?
json.is_edited message.created_at != message.updated_at
json.shared_messaged message.shared_message_id
json.sender_avatar url_for(message.profile.profile_image) if message.profile.profile_image.attached?
json.partial! 'api/v1/reactions/partials/reactions', reactions: message.reactions
json.isSaved saved?(message)
json.pinned message.pin.present?
if message.pin.present?
  json.pin do
    json.id message.pin.id
    json.pinned_by message.pin.profile.username
  end
end
json.receiver_name @receiver.username if @receiver.present?
json.channel_name @bench_channel.name if @bench_channel.present?
if message.parent_message_id.blank?
  json.replies message.replies do |reply|
    json.partial! 'api/v1/shared/partials/message', message: reply
  end
  json.draft_message do
    if get_draft(message.bench_conversation_id, message.id).present?
      json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_draft(message.bench_conversation_id, message.id)
    end
  end
end
if message.shared_message_id.present?
  json.shared_message do
    json.partial! 'api/v1/shared/partials/message', message: ConversationMessage.find_by(id: message.shared_message_id)
  end
end
json.bench_conversation_id message.bench_conversation_id
if message.message_attachments.present?
  json.attachments message.message_attachments do |attachment|
    json.attachment do
      json.extract! attachment.blob, :id, :created_at, :content_type, :filename
    end
    json.attachment_link rails_storage_proxy_url(attachment)
    json.attachment_download_link rails_blob_url(attachment, disposition: 'attachment')
  end
end
json.bench_conversation message.bench_conversation_id
json.conversationable_type message.bench_conversation.conversationable_type
json.conversationable_id message.bench_conversation.conversationable_id
json.channel_name message.bench_conversation.conversationable.name if
  message.bench_conversation.conversationable_type.eql?('BenchChannel')

json.group_id message.bench_conversation.conversationable_id if
  message.bench_conversation.conversationable_type.eql?('Group')

if message.bench_conversation.conversationable_type.eql?('Profile')
  if message.bench_conversation.conversationable_id == message.sender_id
    json.receiver_id message.bench_conversation.sender_id
    json.receiver_name message.bench_conversation.sender.username
  else
    json.receiver_id message.bench_conversation.conversationable_id
    json.receiver_name message.bench_conversation.conversationable.username
  end
end
