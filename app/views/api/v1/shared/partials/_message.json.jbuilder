json.id message.id
json.content message.content
json.is_threaded message.is_threaded
json.parent_message_id message.parent_message_id
json.sender_id message.sender_id
json.sender_name message.profile.username
json.reactions message.reactions
json.created_at message.created_at
json.updated_at message.updated_at
json.isSaved saved?(message)
json.receiver_name @receiver.username if @receiver.present?
json.channel_name @bench_channel.name if @bench_channel.present?
json.group_name @group.name if @group.present?
json.reaction_users message.reactions do |reaction|
  json.username reaction.user.name
  json.reaction reaction.emoji
end
json.replies message.replies do |reply|
  json.id reply.id
  json.content reply.content
  json.is_threaded reply.is_threaded
  json.parent_message_id reply.parent_message_id
  json.sender_id reply.sender_id
  json.sender_name reply.profile.username
  json.reactions reply.reactions
  json.created_at reply.created_at
  json.updated_at reply.updated_at
  json.receiver_name @receiver.username if @receiver.present?
  json.channel_name @bench_channel.name if @bench_channel.present?
  json.group_name @group.name if @group.present?
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
