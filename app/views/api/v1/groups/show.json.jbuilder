json.id @group.id
json.group_chat_name @group.fetch_group_chat_name
json.created_at @group.created_at
json.updated_at @group.updated_at
json.draft_message do
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_draft(@group.bench_conversation.id, nil) if get_draft(
    @group.bench_conversation.id, nil
  ).present?
end
json.partial! 'api/v1/shared/partials/profiles', profiles: @profiles
