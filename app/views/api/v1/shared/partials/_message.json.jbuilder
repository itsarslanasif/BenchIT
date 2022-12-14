json.id message.id
json.content message.content
json.is_threaded message.is_threaded
json.parent_message_id message.parent_message_id
json.sender_id message.sender_id
json.sender_name message.user.name
json.reactions message.reactions
json.created_at message.created_at
json.updated_at message.updated_at
json.receiver_name @receiver.name if @receiver.present?
json.channel_name @bench_channel.name if @bench_channel.present?
if message.message_attachments.present?
  json.attachments message.message_attachments do |attachment|
    json.attachment do
      json.extract! attachment.blob, :id, :created_at, :content_type, :filename
    end
    json.attachment_link rails_storage_proxy_url(attachment)
  end
end
