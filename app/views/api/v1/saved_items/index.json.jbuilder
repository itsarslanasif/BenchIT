json.array! @saved_items do |saved_item|
  json.id saved_item.id
  json.message saved_item.conversation_message
  json.profile saved_item.conversation_message.profile
  json.isSaved true
end
