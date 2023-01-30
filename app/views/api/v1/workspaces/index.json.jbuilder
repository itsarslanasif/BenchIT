json.workspaces @workspaces do |workspace|
  json.partial! 'api/v1/shared/partials/workspace', workspace: workspace
end

