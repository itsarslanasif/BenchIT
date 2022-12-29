json.id @group.id
json.name @group.name
json.created_at @group.created_at
json.updated_at @group.updated_at
json.partial! 'api/v1/shared/partials/profiles', profiles: Profile.where(id: @group.profile_ids)
