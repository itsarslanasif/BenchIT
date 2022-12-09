json.id message.id
json.content message.content
json.is_threaded message.is_threaded
json.parent_message_id message.parent_message_id
json.sender_id message.sender_id
json.sender_name message.user.name
json.reactions message.reactions
json.created_at message.created_at
json.updated_at message.updated_at
json.receiver_name @receiver.name if @receiver.present?
json.channel_name @bench_channel.name if @bench_channel.present?
json.replies message.replies do |reply|
  json.id reply.id
  json.content reply.content
  json.is_threaded reply.is_threaded
  json.parent_message_id reply.parent_message_id
  json.sender_id reply.sender_id
  json.sender_name reply.user.name
  json.reactions reply.reactions
  json.created_at reply.created_at
  json.updated_at reply.updated_at
  json.receiver_name @receiver.name if @receiver.present?
  json.channel_name @bench_channel.name if @bench_channel.present?
end
