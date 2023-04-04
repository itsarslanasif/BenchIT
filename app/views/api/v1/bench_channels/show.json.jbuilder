json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: @bench_channel
json.creator_name @bench_channel.creator.username
json.partial! 'api/v1/shared/partials/bookmarks', object: @bench_channel
json.draft_message do
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_draft(@bench_channel.bench_conversation.id) if get_draft(
    @bench_channel.bench_conversation.id
  ).present?
end
json.isScheduled? scheduled?(@bench_channel.bench_conversation.id)
json.partial! 'api/v1/shared/partials/profiles', profiles: @bench_channel.profiles
json.topic @bench_channel.bench_conversation.topic
