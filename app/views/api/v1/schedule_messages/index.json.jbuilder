json.array! @messages do |message|
  json.partial! 'api/v1/schedule_messages/partials/message', message: message
end
