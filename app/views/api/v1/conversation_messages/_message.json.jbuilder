json.id message.id
json.content message.content
json.is_threaded message.is_threaded
json.parent_message_id message.parent_message_id
json.sender_id message.sender_id
json.sender_name message.user.name
json.reactions message.reactions
json.created_at message.created_at
json.updated_at message.updated_at
json.bench_conversation message.bench_conversation_id
json.conversationable_type message.bench_conversation.conversationable_type
json.conversationable_id message.bench_conversation.conversationable_id
json.channel_name message.bench_conversation.conversationable.name if
  message.bench_conversation.conversationable_type == 'BenchChannel'
json.group_id message.bench_conversation.conversationable_id if message.bench_conversation.conversationable_type == 'Group'
if message.bench_conversation.conversationable_type == 'User'
  if message.bench_conversation.conversationable_id == message.sender_id
    json.receiver_id message.bench_conversation.sender_id
    json.receiver_name User.find(message.bench_conversation.sender_id).name
  else
    json.receiver_id message.bench_conversation.conversationable_id
    json.receiver_name message.bench_conversation.conversationable.name
  end
end
