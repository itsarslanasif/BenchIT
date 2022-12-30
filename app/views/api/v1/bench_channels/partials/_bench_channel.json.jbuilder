json.extract! bench_channel, :id, :name, :description, :creator_id, :created_at, :updated_at
json.partial! 'api/v1/shared/partials/profiles', profiles: bench_channel.profiles
