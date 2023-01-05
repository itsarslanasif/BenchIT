json.workspace @workspace
json.profile do
  json.partial! 'api/v1/shared/partials/profile', profile: @profile
end
