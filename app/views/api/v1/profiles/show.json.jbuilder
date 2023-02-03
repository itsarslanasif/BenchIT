json.partial! 'api/v1/shared/partials/profile', profile: @profile
json.isScheduled? schedule_profile(@profile.id)
