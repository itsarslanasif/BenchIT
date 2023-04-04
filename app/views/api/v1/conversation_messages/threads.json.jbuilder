json.array! @threads do |message|
  json.partial! 'api/v1/shared/partials/message', message: message
end
