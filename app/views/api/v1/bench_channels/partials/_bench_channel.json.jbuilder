json.extract! bench_channel, :id, :name, :description, :creator_id, :created_at, :updated_at, :is_private
json.creator_name bench_channel.creator.username
json.draft_message any_draft(@bench_channel.bench_conversation.id)
json.partial! 'api/v1/shared/partials/profiles', profiles: bench_channel.profiles
