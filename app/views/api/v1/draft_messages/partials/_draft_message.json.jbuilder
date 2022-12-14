json.id draft_message.id
json.content draft_message.content
json.conversationable_id draft_message.bench_conversation.conversationable_id
json.conversationable_type draft_message.bench_conversation.conversationable_type
json.channel_name draft_message.bench_conversation.conversationable.name if draft_message.bench_conversation.conversationable_type == 'BenchChannel'
json.group_id draft_message.bench_conversation.conversationable_id if draft_message.bench_conversation.conversationable_type == 'Group'
if draft_message.bench_conversation.conversationable_type == 'User'
  if draft_message.bench_conversation.conversationable_id == draft_message.user_id
    json.receiver_id draft_message.bench_conversation.sender_id
    json.receiver_name User.find(draft_message.bench_conversation.sender_id).name
  else
    json.receiver_id draft_message.bench_conversation.conversationable_id
    json.receiver_name draft_message.bench_conversation.conversationable.name
  end
end
