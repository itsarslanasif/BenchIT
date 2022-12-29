json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: @bench_channel
json.partial! 'api/v1/shared/partials/profiles', profiles: @bench_channel.profiles
