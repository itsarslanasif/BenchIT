json.workspace do
  json.partial! 'api/v1/shared/partials/workspace', workspace: @workspace
end
json.profile do
  json.partial! 'api/v1/shared/partials/profile', profile: @profile
end
json.preferences @profile.preference
