json.id draft_message.id
json.content draft_message.content
json.conversationable_id draft_message.bench_conversation.conversationable_id
json.conversationable_type draft_message.bench_conversation.conversationable_type
if draft_message.bench_conversation.conversationable_type.eql?('BenchChannel')
  json.channel_name draft_message.bench_conversation.conversationable.name
end
json.group_id draft_message.bench_conversation.conversationable_id if draft_message.bench_conversation.conversationable_type.eql?('Group')
if draft_message.bench_conversation.conversationable_type.eql?('Profile')
  if draft_message.bench_conversation.conversationable_id == draft_message.profile_id
    json.receiver_id draft_message.bench_conversation.sender_id
    json.receiver_name draft_message.bench_conversation.sender.username
  else
    json.receiver_id draft_message.bench_conversation.conversationable_id
    json.receiver_name draft_message.bench_conversation.conversationable.name
  end
end
