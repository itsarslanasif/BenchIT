json.id @group.id
json.group_chat_name @group.fetch_group_chat_name
json.created_at @group.created_at
json.updated_at @group.updated_at
json.draft_message get_draft(@group.bench_conversation.id)
json.partial! 'api/v1/shared/partials/profiles', profiles: @profiles
