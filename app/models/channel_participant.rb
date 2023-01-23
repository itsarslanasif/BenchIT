class ChannelParticipant < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_channel

  validates :permission, presence: true
  validates :bench_channel, uniqueness: { scope: %i[profile_id] }

  after_commit :broadcast_channel, :broadcast_member_profile

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
end
