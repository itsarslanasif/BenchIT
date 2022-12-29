class Api::V1::BookmarksController < Api::ApiController
  before_action :find_bookmark , only: %i[update destroy]
  def index
    @bookmarks = Bookmark.with_bookmarkable_id_and_type(params[:bookmarkable_id], params[:bookmarkable_type])
  end

  def create
    @bookmark = Bookmark.create(bookmark_params)

    render json: @bookmark.errors if @bookmark.errors.any?
  end

  def update
    if @bookmark.update(bookmark_params)
      render json: { message: 'Bookmark updated', bookmark: @bookmark }
    else
      render json: { error: @bookmark.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    render json: @bookmark.destroy ? { message: 'Bookmark deleted' } : { error: @bookmark.errors, status: :unprocessable_entity }
  end

  def find_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL, :bookmarkable_type, :bookmarkable_id)
  end
end
