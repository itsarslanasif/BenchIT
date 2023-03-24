json.partial! 'api/v1/bench_channels/partials/bench_channel', bench_channel: @bench_channel
json.creator_name @bench_channel.creator.username
json.bookmarks @bench_channel.bookmarks.where(bookmark_folder_id: nil)
json.bookmark_folders @bench_channel.bookmark_folders do |bookmark_folder|
  json.id bookmark_folder.id
  json.name bookmark_folder.name
  json.bookmarks bookmark_folder.bookmarks 
end
json.draft_message do
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_draft(@bench_channel.bench_conversation.id) if get_draft(
    @bench_channel.bench_conversation.id
  ).present?
end
json.isScheduled? scheduled?(@bench_channel.bench_conversation.id)
json.partial! 'api/v1/shared/partials/profiles', profiles: @bench_channel.profiles
