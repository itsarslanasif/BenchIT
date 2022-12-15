json.array! bench_channels do |_bench_channel|
  json.partial! '/api/v1/bench_channels/partials/_bench_channel', message: message
end
