json.partial! 'api/v1/shared/partials/profile', profile: @profile
json.isScheduled? profile_scheduled(@profile.id)
