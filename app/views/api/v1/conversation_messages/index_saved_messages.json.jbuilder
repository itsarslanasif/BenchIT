json.saved_items @saved_items do |saved_item|
  json.partial! 'api/v1/conversation_messages/saved_message', saved_item: saved_item
end
