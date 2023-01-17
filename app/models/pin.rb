class Pin < ApplicationRecord
  after_commit :broadcast_pin

  belongs_to :conversation_message
  belongs_to :profile
  belongs_to :bench_conversation

  private

  def broadcast_pin
    conversation_message.pin = nil if destroyed?
    result = {
      content: conversation_message.message_content,
      type: 'Pin'
    }
    result[:action] = if destroyed?
                        'Delete'
                      elsif created_at.eql?(updated_at)
                        'Create'
                      else
                        'Update'
                      end
    BroadcastMessageChatService.new(result, bench_conversation).call
  end
end
