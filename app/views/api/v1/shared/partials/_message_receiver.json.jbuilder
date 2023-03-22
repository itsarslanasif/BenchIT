json.conversation_type message.bench_conversation.conversationable_type
if message.bench_conversation.conversationable_type.eql?('Profile')
  json.receiver do
    if message.bench_conversation.conversationable_id.eql?(@current_profile.id)
      json.partial! 'api/v1/shared/partials/profile', profile: message.bench_conversation.sender
    else
      json.partial! 'api/v1/shared/partials/profile', profile: message.bench_conversation.conversationable
    end
  end
else
  json.receiver do
    if message.bench_conversation.conversationable_type.eql?('Group')
      json.partial! 'api/v1/groups/partials/group', group: message.bench_conversation.conversationable
    else
      json.partial! 'api/v1/bench_channels/partials/channel', channel: message.bench_conversation.conversationable
    end
  end
end
