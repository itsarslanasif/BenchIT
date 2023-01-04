json.extract! reaction, :id, :emoji, :conversation_message_id, :profile_id
json.reacted_by reaction.profile.username
