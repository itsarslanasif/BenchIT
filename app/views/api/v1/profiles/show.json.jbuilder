json.id @profile.id
json.workspace_id @profile.workspace_id
json.user_id @profile.user_id
json.username @profile.username
json.description @profile.description
json.display_name @profile.display_name
json.pronounce_name @profile.pronounce_name
json.title @profile.title
json.text_status @profile.text_status
json.emoji_status @profile.emoji_status
json.phone @profile.phone
json.skype @profile.skype
json.time_zone Time.current.in_time_zone(@profile.time_zone).strftime('%I:%M %p')
json.image_url url_for(@profile.profile_image) if @profile.profile_image.attached?
json.email @profile.user.email
