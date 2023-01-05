class Pin < ApplicationRecord
  after_commit :broadcast_pin

  belongs_to :conversation_message
  belongs_to :profile
  belongs_to :bench_conversation

  private

  def broadcast_pin
    result = {
      content: pin_content,
      type: 'Pin'
    }
    result[:action] = if destroyed?
                        'Delete'
                      elsif created_at.eql?(updated_at)
                        'Create'
                      else
                        'Update'
                      end
    BroadcastMessageService.new(result, bench_conversation).call
  end

  def pin_content
    {
      id: id,
      conversation_message_id: conversation_message_id,
      pin_by: profile.username,
      count: bench_conversation.pins.size
    }
  end
end
