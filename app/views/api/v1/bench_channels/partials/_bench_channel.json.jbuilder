json.extract! bench_channel, :id, :name, :description, :creator_id, :created_at, :updated_at, :is_private
json.partial! 'api/v1/shared/partials/profiles', profiles: bench_channel.profiles
json.creator_name bench_channel.creator.username
json.bench_conversation_id bench_channel.bench_conversation&.id
