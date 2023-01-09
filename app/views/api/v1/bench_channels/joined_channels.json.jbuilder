json.array! @bench_channels do |channel|
  json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: channel
  json.is_favourite Current.profile.favourite?(channel.id,"BenchChannel")
end
