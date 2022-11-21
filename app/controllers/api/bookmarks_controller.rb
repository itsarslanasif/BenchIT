class Api::BookmarksController < Api::ApiController
  before_action :set_channel, only: %i[index create]

  def create
    @bookmark = @channel.bookmarks.create(bookmark_params)

    render json: @bookmark.errors if @bookmark.errors.any?
  end

  def index
    @bookmarks = @channel.bookmarks
  end

  private

  def set_channel
    @channel = BenchChannel.find_by!(id: params[:bench_channel_id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL, :user_id, :bench_channel_id)
  end

end
