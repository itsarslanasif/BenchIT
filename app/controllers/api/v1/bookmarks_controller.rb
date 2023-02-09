class Api::V1::BookmarksController < Api::ApiController
  include MemberShip

  before_action :initialize_bookmark, only: %i[create]
  before_action :set_bookmark, only: %i[destroy update]
  before_action :authenticate_bookmark, only: %i[create update destroy]

  def index
    @bookmarks = Bookmark.with_bookmarkable_id_and_type(params[:bookmarkable_id], params[:bookmarkable_type])
  end

  def create
    @bookmark.save!
    render json: { success: true, message: I18n.t('api.v1.controllers.bookmarks.create.success') }, status: :ok
  end

  def update
    @bookmark.update!(bookmark_params)
    render json: { success: true, message: I18n.t('api.v1.controllers.bookmarks.update.success') }, status: :ok
  end

  def destroy
    @bookmark.destroy!
    render json: { success: true, message: I18n.t('api.v1.controllers.bookmarks.destroy.success') }, status: :ok
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:name, :bookmark_URL, :bookmarkable_type, :bookmarkable_id).tap do |param|
      param[:profile_id] = current_profile.id
    end
  end

  def authenticate_bookmark
    conversation = if @bookmark.bookmarkable_type.eql?('Profile')
                     BenchConversation.profile_to_profile_conversation(@bookmark.bookmarkable_type, @bookmark.profile_id)
                   else
                     @bookmark.bookmarkable.bench_conversation
                   end
    check_membership(conversation)
  end

  def initialize_bookmark
    @bookmark = Bookmark.new(bookmark_params)
  end
end
