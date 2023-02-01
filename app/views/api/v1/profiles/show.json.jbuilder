json.partial! 'api/v1/shared/partials/profile', profile: @profile
json.draft_message any_draft(@profile.id)
