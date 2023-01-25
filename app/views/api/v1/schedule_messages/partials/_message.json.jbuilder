json.extract! message, :id, :content
json.scheduled_at message.scheduled_at.to_time.in_time_zone(Current.profile.time_zone)
json.conversation_type message.bench_conversation.conversationable_type
if message.bench_conversation.conversationable_type.eql?('Profile')
  json.receiver do
    if message.bench_conversation.conversationable_id.eql?(message.profile_id)
      json.partial! 'api/v1/shared/partials/profile', profile: message.profile
    else
      json.partial! 'api/v1/shared/partials/profile', profile: message.bench_conversation.conversationable
    end
  end
else
  json.receiver message.bench_conversation.conversationable
end
