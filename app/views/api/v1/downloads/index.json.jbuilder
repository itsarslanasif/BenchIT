@downloads.each do |download|
  if download.file.present?
      json.file do
        json.extract! download.file.blob, :id, :created_at, :content_type, :filename
      end
      json.file_link rails_storage_proxy_url(download.file)
      json.file_download_link rails_blob_url(download.file, disposition: 'attachment')
  end
end
