json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: @bench_channel
json.creator_name @bench_channel.creator.username
json.isScheduled? scheduled?(@bench_channel.bench_conversation.id)
json.partial! 'api/v1/shared/partials/profiles', profiles: @bench_channel.profiles
