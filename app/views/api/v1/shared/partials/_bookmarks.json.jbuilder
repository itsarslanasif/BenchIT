json.bookmarks object.bookmarks.where(bookmark_folder_id: nil)
json.bookmark_folders object.bookmark_folders.includes(:bookmarks) do |bookmark_folder|
  json.id bookmark_folder.id
  json.name bookmark_folder.name
  json.bookmarks bookmark_folder.bookmarks
end
