
# json.partial! 'api/v1/shared/partials/profile', profile: Current.profile
# debugger
json.profile do
  render partial: 'api/v1/shared/partials/profile', locals: { profile: @current_profile }, formats: :json
end
debugger
