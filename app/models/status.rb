class Status < ApplicationRecord
  enum type: { ProfileStatus: 0, RecentStatus: 1, WorkspaceStatus: 2 }

  after_commit :broadcast_status

  def broadcast_status
    result = {
      content: status_content,
      type: 'Status'
    }
    result[:action] = if destroyed?
                        'Delete'
                      elsif created_at.eql?(updated_at)
                        'Create'
                      else
                        'Update'
                      end

    BroadcastMessageService.new(result,1).send_notification_ws(Current.workspace.profile_ids)
  end

  def status_content
    {
      id: id,
      text: text,
      emoji: emoji,
      clear_after: clear_after,
      profile_id: profile_id,
      type: type,
      workspace_id: workspace_id
    }
  end

end
