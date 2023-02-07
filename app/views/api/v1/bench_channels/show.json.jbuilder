json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: @bench_channel
json.creator_name @bench_channel.creator.username
json.draft_message do
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_draft(@bench_channel.bench_conversation.id, nil) if get_draft(
    @bench_channel.bench_conversation.id, nil
  ).present?
end
json.partial! 'api/v1/shared/partials/profiles', profiles: @bench_channel.profiles
