class Api::V1::BookmarksController < Api::ApiController
  include MemberShip
  before_action :fetch_conversation, only: %i[create]
  before_action :set_bookmark, only: %i[destroy update]
  before_action :authenticate_bookmark, only: %i[create update destroy]

  def create
    @bookmark = @bench_conversation.bookmarks.new(bookmark_params)
    @bookmark.save!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def update
    @bookmark.update!(bookmark_params)
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def destroy
    @bookmark.destroy!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
    @bench_conversation = @bookmark.bench_conversation
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL)
  end

  def authenticate_bookmark
    check_membership(@bench_conversation)
  end

  def fetch_conversation
    @bench_conversation = BenchConversation.find(params[:bench_conversation_id])
  end
end
