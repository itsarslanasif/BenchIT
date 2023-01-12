class Api::V1::DownloadsController < Api::ApiController
  before_action :set_download, only: :destroy
  before_action :set_all_downloads, only: %i[index destroy_all]

  def index; end

  def create
    @download = Current.profile.downloads.new(download_params)
    if @download.save
      render json: @download, status: :ok
    else
      render json: @download.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @download.destroy
      render json: 'download removed', status: :ok
    else
      render json: @download.errors, status: :unprocessable_entity
    end
  end

  def destroy_all
    if @downloads.destroy_all
      render json: 'downloads removed', status: :ok
    else
      render json: @downloads.errors, status: :unprocessable_entity
    end
  end

  private

  def download_params
    params.require(:download).permit(:file_name, :file_link, :file_download_link, :file_type)
  end

  def set_download
    @download = Current.profile.downloads.find(params[:id])
  end

  def set_all_downloads
    @downloads = Current.profile.downloads.order(created_at: :desc)
  end
end
