class Api::V1::BookmarksController < Api::ApiController
  include CanAuthorization
  before_action :initialize_bookmark, only: %i[create]
  before_action :set_bookmark, only: %i[destroy update]
  before_action :authenticate_bookmark, only: %i[create update destroy]

  def create
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
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL, :bookmark_folder_id)
  end

  def authenticate_bookmark
    authorize_action(action_name, @bookmark)
  end

  def initialize_bookmark
    @bench_conversation = BenchConversation.find(params[:bench_conversation_id])
    @bookmark = @bench_conversation.bookmarks.new(bookmark_params)
  end
end
