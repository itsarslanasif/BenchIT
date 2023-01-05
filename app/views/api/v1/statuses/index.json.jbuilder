json.recent_statuses @recent_statuses do |status|
  json.id status.id
  json.text status.text
  json.emoji status.emoji
  json.clear_after status.clear_after
end

json.workspace_statuses @workspace_statuses do |status|
  json.id status.id
  json.text status.text
  json.emoji status.emoji
  json.clear_after status.clear_after
end
