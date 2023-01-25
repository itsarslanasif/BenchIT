json.array! @last_messages do |message|
  json.partial! 'api/v1/shared/partials/message', message: message
end
