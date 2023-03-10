class ChannelParticipant < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_channel

  validates :permission, presence: true
  validates :bench_channel, uniqueness: { scope: %i[profile_id] }

  before_create :set_role_and_id
  after_commit :broadcast_channel, :broadcast_member_profile

  enum role: {
    member: 0,
    channel_manager: 1
  }

  private

  def broadcast_channel
    return unless ActionPerformed.new.action_performed(self).eql?('Create')

    message = channel_participant_content
    message[:content] = bench_channel.bench_channel_content

    BroadcastMessageNotificationService.new(message, [profile_id]).call
  end

  def broadcast_member_profile
    return if ActionPerformed.new.action_performed(self).eql?('Update')

    message = channel_participant_content
    message[:content] = profile.profile_content

    BroadcastMessageChatService.new(message, bench_channel.bench_conversation).call
  end

  def channel_participant_content
    {
      type: 'ChannelParticipant',
      action: ActionPerformed.new.action_performed(self)
    }
  end

  def set_role_and_id
    self.role = if bench_channel.creator_id.eql?(profile_id) || profile.workspace_owner? || profile.workspace_admin?
                  :channel_manager
                else
                  :member
                end
    self.id = bench_channel_id + profile_id
  end
end
