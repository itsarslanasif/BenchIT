json.id @group.id
json.group_name @group.fetch_group_name
json.created_at @group.created_at
json.updated_at @group.updated_at
json.partial! 'api/v1/shared/partials/profiles', profiles: @profiles
