json.array! @saved_items do |saved_item|
  json.id saved_item.id
  json.message saved_item.conversation_message
end
