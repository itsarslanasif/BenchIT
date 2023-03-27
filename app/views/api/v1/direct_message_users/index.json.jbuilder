json.array! @profiles || profile do |profile|
  json.partial! 'api/v1/shared/partials/profile', profile: profile
  json.favourite_id Current.profile.get_favourite_id(profile.id, 'Profile')
end
