json.bookmarks @bookmarks do |bookmark|
  json.partial! partial: '/api/bookmarks/shared/bookmarks', locals: {
    bookmark: bookmark
  }
end
