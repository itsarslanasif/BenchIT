class Api::V1::BookmarksController < Api::ApiController
  before_action :set_channel, only: %i[index]

  def index
    @bookmarks = Bookmark.with_bookmarkid_and_bookmarktype(@bookmark_id, @bookmark_type)
  end

  def create
    @bookmark = Bookmark.create(bookmark_params)
    render json: @bookmark.errors if @bookmark.errors.any?
  end

  private

  def set_channel
    @bookmark_id = params[:bookmarkable_id]
    @bookmark_type = params[:bookmarkable_type]
    return render json: { message: 'Invalid', status: :not_found } if @bookmark_id.blank? || @bookmark_type.blank?
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL, :bookmarkable_type, :bookmarkable_id).tap do |param|
      param[:profile_id] = Current.profile.id
    end
  end
end
