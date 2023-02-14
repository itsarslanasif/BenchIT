json.array! @draft_messages do |message|
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: message
end
