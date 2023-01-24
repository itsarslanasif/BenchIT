json.extract! message, :id, :content, :job_id, :profile_id, :scheduled_at, :created_at, :updated_at
json.sender_name message.profile.username
json.conversation_type message.bench_conversation.conversationable_type
if message.bench_conversation.conversationable_type.eql?('Profile')
  if message.bench_conversation.conversationable_id == message.profile_id
    json.receiver_id message.profile_id
    json.receiver_name message.profile.username
  else
    json.receiver_id message.bench_conversation.conversationable_id
    json.receiver_name message.bench_conversation.conversationable.username
  end
else
  json.receiver_id message.bench_conversation.conversationable_id
  json.receiver_name message.bench_conversation.conversationable.name
end
