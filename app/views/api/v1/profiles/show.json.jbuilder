json.partial! 'api/v1/shared/partials/profile', profile: @profile
json.draft_message do
  json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_profile_draft(@profile.id) if get_profile_draft(@profile.id).present?
end
json.isScheduled? schedule_profile(@profile.id)
