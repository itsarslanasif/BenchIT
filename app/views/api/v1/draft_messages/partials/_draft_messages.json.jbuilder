json.array! draft_messages do |draft_message|
  json.partial! 'api/v1/draft_messages/partials/draft_message', draft_message: draft_message
end
