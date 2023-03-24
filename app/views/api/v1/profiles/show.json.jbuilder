json.partial! 'api/v1/shared/partials/profile', profile: @profile
json.draft_message do
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_profile_draft(@profile.id) if get_profile_draft(@profile.id).present?
end
json.isScheduled? schedule_profile(@profile.id)
conversation = get_profile_conversation(@profile.id)
json.bench_conversation_id conversation.id
json.bookmarks conversation.bookmarks.where(bookmark_folder_id: nil)
json.bookmark_folders conversation.bookmark_folders do |bookmark_folder|
  json.id bookmark_folder.id
  json.name bookmark_folder.name
  json.bookmarks bookmark_folder.bookmarks 
end
