json.groups @groups do |group|
  json.partial! 'api/v1/groups/partials/group', group: group
  json.draft_message do
    json.partial! 'api/v1/draft_messages/partials/draft_message', message: get_draft(group.bench_conversation.id) if get_draft(
      group.bench_conversation.id
    ).present?
  end
  json.isScheduled? scheduled?(group.bench_conversation.id)

  json.bench_conversation_id group.bench_conversation.id
end
