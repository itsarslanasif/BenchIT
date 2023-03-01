json.schedule_messages @messages do |message|
  json.partial! 'api/v1/schedule_messages/partials/message', message: message
end
json.page_information @pagy if @pagy.present?
