json.array! @bench_channels do |channel|
  json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: channel
  json.favourite_id @current_profile.get_favourite_id(channel.id, 'BenchChannel')
  json.is_muted muted?(channel.id)
end
