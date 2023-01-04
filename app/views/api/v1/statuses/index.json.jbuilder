json.recent_statuses @recent_statuses do |status|
  json.text status.text
  json.emoji status.emoji
  json.clear_after status.clear_after
end

json.workspace_statuses @workspace_statuses do |status|
  json.text status.text
  json.emoji status.emoji
  json.clear_after status.clear_after
end
