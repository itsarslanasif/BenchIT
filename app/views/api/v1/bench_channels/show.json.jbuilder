json.id @bench_channel.id
json.name @bench_channel.name
json.description @bench_channel.description
json.creator_id @bench_channel.creator_id
json.creator_name @bench_channel.creator.username
json.created_at @bench_channel.created_at
json.updated_at @bench_channel.updated_at
json.partial! 'api/v1/shared/partials/profiles', profiles: @bench_channel.profiles
