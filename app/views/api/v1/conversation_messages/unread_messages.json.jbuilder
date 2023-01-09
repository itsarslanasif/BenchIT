json.array! @previous_unread_messages_details.keys do |key|
  message_ids = @previous_unread_messages_details[key]
  json.bench_conversation = key
  json.messages do
    json.partial! 'api/v1/conversation_messages/messages', messages: messages_from_ids(message_ids)
  end
end
