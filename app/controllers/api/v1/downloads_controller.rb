class Api::V1::DownloadsController < Api::ApiController
  def create
    @download = Download.create(download_params)
  end

  def index
    @downloads = Current.profile.downloads
  end

  private

  def download_params
    params.permit(:file).tap do |param|
      param[:profile] = Current.profile
    end
  end

end
