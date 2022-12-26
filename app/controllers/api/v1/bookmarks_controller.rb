class Api::V1::BookmarksController < Api::ApiController
  before_action :set_bookmark_id_and_type, only: %i[index]

  def index
    @bookmarks = Bookmark.with_bookmarkid_and_bookmarktype(@bookmark_id, @bookmark_type)
  end

  def create
    @bookmark = Bookmark.create(bookmark_params)

    render json: @bookmark.errors if @bookmark.errors.any?
  end

  private

  def set_bookmark_id_and_type
    @bookmark_id = params[:bookmarkable_id]
    @bookmark_type = params[:bookmarkable_type]
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL, :bookmarkable_type, :bookmarkable_id).tap do |param|
      param[:profile_id] = Current.profile.id
    end
  end
end
