json.id profile.id
json.username profile.username
json.description profile.description
json.workspace_id profile.workspace_id
json.user_id profile.user_id
json.image_url url_for(profile.profile_image) if profile.profile_image.attached?
json.display_name profile.display_name
json.pronounce_name profile.pronounce_name
json.role profile.role
json.title profile.title
json.status do
  json.text profile.text_status
  json.emoji profile.emoji_status
end
json.contact_info do
  json.email profile.user.email
  json.phone profile.phone
end
json.about_me do
  json.skype profile.skype
end
json.local_time Time.current.in_time_zone(profile.time_zone).strftime('%I:%M %p')
