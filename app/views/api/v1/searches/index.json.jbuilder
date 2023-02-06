json.messages @results do |result|
  json.partial! 'api/v1/shared/partials/message', message: result if result.instance_of?(ConversationMessage)
end
json.profiles @results do |result|
  json.partial! 'api/v1/shared/partials/profile', profile: result if result.instance_of?(Profile)
end
json.channels @results do |result|
  json.extract! result, :id, :name, :description, :creator_id, :created_at, :updated_at, :is_private if result.instance_of?(BenchChannel)
end
