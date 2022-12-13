json.id message.id
json.content message.content
json.is_threaded message.is_threaded
json.parent_message_id message.parent_message_id
json.sender_id message.sender_id
json.sender_name message.user.name
json.reactions message.reactions
json.created_at message.created_at
json.updated_at message.updated_at
json.type message.bench_conversation.conversationable_type
json.receiver_name User.find_by(id: message.bench_conversation.conversationable_id).name if message.bench_conversation.conversationable_type == 'User'
json.channel_name BenchChannel.find_by(id: message.bench_conversation.conversationable_id).name if message.bench_conversation.conversationable_type == 'BenchChannel'
json.group_id message.bench_conversation.conversationable_id if message.bench_conversation.conversationable_type == 'Group'
