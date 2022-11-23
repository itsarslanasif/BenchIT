json.bookmarks @bookmarks do |bookmark|
  json.partial! partial: '/api/v1/bookmarks/shared/bookmarks', locals: {
    bookmark: bookmark
  }
end
