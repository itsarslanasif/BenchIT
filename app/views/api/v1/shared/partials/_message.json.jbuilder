json.extract! message, :id, :content, :is_threaded, :parent_message_id, :sender_id, :created_at, :updated_at
json.sender_name message.profile.username
json.partial! 'api/v1/reactions/partials/reactions', reactions: message.reactions
json.sender_avatar url_for(message.profile.profile_image) if message.profile.profile_image.attached?
json.reactions message.reactions
json.created_at message.created_at
json.updated_at message.updated_at
json.is_edited message.created_at != message.updated_at
json.partial! 'api/v1/reactions/partials/reactions', reactions: message.reactions
json.isSaved saved?(message)
json.receiver_name @receiver.username if @receiver.present?
json.channel_name @bench_channel.name if @bench_channel.present?
json.replies message.replies do |reply|
  json.id reply.id
  json.content reply.content
  json.is_threaded reply.is_threaded
  json.parent_message_id reply.parent_message_id
  json.sender_id reply.sender_id
  json.sender_name reply.profile.username
  json.partial! 'api/v1/reactions/partials/reactions', reactions: reply.reactions
  json.sender_avatar url_for(reply.profile.profile_image) if reply.profile.profile_image.attached?
  json.reactions reply.reactions
  json.created_at reply.created_at
  json.updated_at reply.updated_at
  json.receiver_name @receiver.username if @receiver.present?
  json.channel_name @bench_channel.name if @bench_channel.present?
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
