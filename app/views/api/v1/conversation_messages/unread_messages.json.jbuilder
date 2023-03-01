json.array! @previous_unread_messages_details.keys do |key|
  first_unread_message_id = @previous_unread_messages_details[key].first
  total_unread_messages = @previous_unread_messages_details[key].second
  json.bench_conversation key
  json.total_unread_messages total_unread_messages
  json.messages do
    json.partial! 'api/v1/conversation_messages/messages', messages: messages_from_ids(first_unread_message_id)
  end
end
