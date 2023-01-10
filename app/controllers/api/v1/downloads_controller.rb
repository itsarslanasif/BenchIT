class Api::V1::DownloadsController < Api::ApiController
  def create
    @download = Download.new(download_params)
    if @download.save
      render json: @download, status: :ok
    else
      render json: @download.errors, status: :unprocessable_entity
    end
  end

  def index
    @downloads = Current.profile.downloads
  end

  private

  def download_params
    params.require(:download).permit(:file_name, :file_link, :file_download_link, :file_type).tap do |param|
      param[:profile] = Current.profile
    end
  end

end
