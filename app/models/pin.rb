class Pin < ApplicationRecord
  include Cablable
  after_destroy :broadcast_unpin
  after_save :broadcast_pin

  belongs_to :conversation_message
  belongs_to :profile
  belongs_to :bench_conversation

  def broadcast_pin
    set_pin
    @result[:action] = 'Pin'
    @result = append_conversation_type_and_id(bench_conversation, @result)
    BroadcastMessageService.new(@result, bench_conversation).call
  end

  def broadcast_unpin
    set_pin
    @result[:action] = 'Unpin'
    @result = append_conversation_type_and_id(bench_conversation, @result)
    BroadcastMessageService.new(@result, bench_conversation).call
  end

  private

  def set_pin
    pin = {
      id: id,
      conversation_message_id: conversation_message_id,
      pin_by: profile.username,
      count: bench_conversation.pins.size
    }
    @result = {
      content: pin,
      type: 'Pin'
    }
    @result[:action] = created_at == updated_at ? 'Create' : 'Update'
  end
end
