class Api::V1::DownloadsController < Api::ApiController
  before_action :set_download, only: :destroy
  before_action :set_all_downloads, only: %i[index clear_all]

  def index; end

  def create
    @download = current_profile.downloads.new(download_params)
    @download.save!
    render json: { success: true, message: I18n.t('api.v1.downloads.create.success') }, status: :ok
  end

  def destroy
    @download.destroy!
    render json: { success: true, message: I18n.t('api.v1.downloads.destroy.success') }, status: :ok
  end

  def clear_all
    @downloads.destroy_all!
    render json: { success: true, message: I18n.t('api.v1.downloads.destroy.success') }, status: :ok
  end

  private

  def download_params
    params.require(:download).permit(:file_name, :file_link, :file_download_link, :file_type)
  end

  def set_download
    @download = current_profile.downloads.find(params[:id])
  end

  def set_all_downloads
    @downloads = current_profile.downloads.order(created_at: :desc)
  end
end
