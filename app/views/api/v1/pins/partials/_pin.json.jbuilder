json.id pin.id
json.pinned_by pin.profile
json.message do
  json.partial! 'api/v1/shared/partials/message', message: pin.conversation_message
end
