class ChannelParticipant < ApplicationRecord
  after_commit :broadcast_channel

  belongs_to :profile
  belongs_to :bench_channel
  validates :permission, presence: true

  private

  def broadcast_channel
    return if action_performed.eql?('Create')

    message = channel_participant_content
    message[:content] = bench_channel.bench_channel_content

    BroadcastMessageService.new(message, bench_channel.bench_conversation).send_notification_ws([profile_id])
  end

  def channel_participant_content
    {
      type: 'ChannelParticipant',
      action: action_performed
    }
  end

  def action_performed
    if destroyed?
      'Delete'
    elsif created_at.eql?(updated_at)
      'Create'
    else
      'Update'
    end
  end
end
