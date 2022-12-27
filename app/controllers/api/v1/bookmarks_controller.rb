class Api::V1::BookmarksController < Api::ApiController
  def index
    @bookmarks = Bookmark.with_bookmarkable_id_and_type(params[:bookmarkable_id], params[:bookmarkable_type])
  end

  def create
    @bookmark = Bookmark.create(bookmark_params)

    render json: @bookmark.errors if @bookmark.errors.any?
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL, :bookmarkable_type, :bookmarkable_id)
  end
end
