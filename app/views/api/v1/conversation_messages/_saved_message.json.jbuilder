json.id saved_item.id
json.message saved_item.conversation_message
json.profile do
  json.partial! 'api/v1/shared/partials/profile', profile: saved_item.conversation_message.profile
end
json.isSaved true
if saved_item.conversation_message.message_attachments.present?
  json.attachments saved_item.conversation_message.message_attachments do |attachment|
    json.attachment do
      json.extract! attachment.blob, :id, :created_at, :content_type, :filename
    end
    json.attachment_link rails_storage_proxy_url(attachment)
    json.attachment_download_link rails_blob_url(attachment, disposition: 'attachment')
  end
end
