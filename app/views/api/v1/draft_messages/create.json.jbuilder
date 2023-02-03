json.success true
json.message 'Draft create'
json.partial! 'api/v1/draft_messages/partials/draft_message', message: @draft_message
json.partial! 'api/v1/shared/partials/message_receiver', message: @draft_message
