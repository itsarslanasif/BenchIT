class Pin < ApplicationRecord
  include UuidGenerator

  after_commit :broadcast_pin

  belongs_to :conversation_message
  belongs_to :profile
  belongs_to :bench_conversation

  validates :bench_conversation, uniqueness: { scope: %i[conversation_message_id] }

  private

  def broadcast_pin
    conversation_message.pin = nil if destroyed?
    result = {
      content: conversation_message.message_content,
      type: 'Pin'
    }
    result[:action] = ActionPerformed.new.action_performed(self)
    BroadcastMessageChatService.new(result, bench_conversation).call
  end
end
