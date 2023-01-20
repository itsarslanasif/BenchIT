# json.array! @bench_channels do |channel|
#   json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: channel
# end
json.bench_channels @bench_channels do |channel|
  json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: channel
end
json.page_information @pagy if @pagy.present?
