json.profiles profiles do |profile|
  json.id profile.id
  json.username profile.username
  json.description profile.description
  json.workspace_id profile.workspace_id
  json.user_id profile.user_id
  json.image_url url_for(profile.profile_image) if profile.profile_image.attached?
end
