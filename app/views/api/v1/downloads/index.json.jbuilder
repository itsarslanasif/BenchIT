json.array! @downloads do |download|
  json.file_name download.file_name
  json.file_link download.file_link
  json.file_download_link download.file_download_link
  json.file_type download.file_type
end
