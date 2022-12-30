json.array! messages do |message|
  json.partial! 'api/v1/shared/partials/message', message: message
end
