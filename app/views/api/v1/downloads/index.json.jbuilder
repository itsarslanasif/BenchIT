json.array! @downloads do |download|
  json.extract! download, :id, :file_name, :file_link, :file_download_link, :file_type
end
