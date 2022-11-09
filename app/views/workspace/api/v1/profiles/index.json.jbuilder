json.profiles @profiles do |profile|
  json.partial! 'workspace/api/v1/models/profile.json.jbuilder', profile: profile
end
