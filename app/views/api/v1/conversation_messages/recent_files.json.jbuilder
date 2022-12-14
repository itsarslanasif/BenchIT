json.array! @messages do |message|
  if message.message_attachments.present?
    message.message_attachments.each do |attachment|
      json.attachment attachment.blob
      json.attachment_link url_for(attachment)
    end
  end
end
