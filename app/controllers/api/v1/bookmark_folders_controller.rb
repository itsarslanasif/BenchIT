class Api::V1::BookmarkFoldersController < Api::ApiController
  include CanAuthorization
  before_action :initialize_bookmark_folder, only: %i[create]
  before_action :set_bookmark_folder, only: %i[destroy update]
  before_action :authenticate_bookmark_folder, only: %i[create update destroy]

  def create
    @bookmark_folder.save!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def update
    @bookmark_folder.update!(bookmark_folder_params)
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def destroy
    @bookmark_folder.destroy!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  private

  def set_bookmark_folder
    @bookmark_folder = BookmarkFolder.find(params[:id])
  end

  def bookmark_folder_params
    params.require(:bookmark_folder).permit(:name)
  end

  def initialize_bookmark_folder
    @bench_conversation = BenchConversation.find(params[:bench_conversation_id])
    @bookmark_folder = @bench_conversation.bookmark_folders.new(bookmark_folder_params)
  end

  def authenticate_bookmark_folder
    authorize_action(action_name, @bookmark_folder)
  end
end
