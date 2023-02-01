json.partial! 'api/v1/shared/partials/profile', profile: @profile
json.draft_message get_profile_draft(@profile.id)
