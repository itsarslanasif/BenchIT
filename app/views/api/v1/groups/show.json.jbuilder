json.extract! @group, :id, :fetch_group_chat_name, :created_at, :updated_at
json.isScheduled? any_scheduled(@group.bench_conversation.id)
json.partial! 'api/v1/shared/partials/profiles', profiles: @profiles
