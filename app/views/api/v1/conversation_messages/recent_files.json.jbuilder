json.array! @messages do |message|
  if message.message_attachments.present?
    message.message_attachments.each do |attachment|
      json.attachment do
        json.extract! attachment.blob, :id, :created_at, :content_type, :filename
      end
      json.attachment_link rails_storage_proxy_url(attachment)
    end
  end
end
