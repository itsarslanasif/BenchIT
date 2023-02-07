json.extract! @group, :id, :fetch_group_chat_name, :created_at, :updated_at
json.draft_message do
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_draft(@group.bench_conversation.id, nil) if get_draft(
    @group.bench_conversation.id, nil
  ).present?
end
json.isScheduled? scheduled?(@group.bench_conversation.id)
json.partial! 'api/v1/shared/partials/profiles', profiles: @profiles
