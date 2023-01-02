class Pin < ApplicationRecord
  include Cablable
  after_create :set_action_create
  after_update :set_action_update
  after_destroy :set_action_delete
  after_commit :broadcast_pin

  belongs_to :conversation_message
  belongs_to :profile
  belongs_to :bench_conversation

  def broadcast_pin
    pin = set_pin
    result = {
      content: pin,
      action: @action,
      type: 'Pin'
    }
    result = append_conversation_type_and_id(bench_conversation, result)
    BroadcastMessageService.new(result, bench_conversation).call
  end

  private

  def set_action_delete
    @action = 'Unpin'
  end

  def set_action_create
    @action = 'Pin'
  end

  def set_action_update
    @action = 'Update'
  end

  def set_pin
    {
      id: id,
      conversation_message_id: conversation_message_id,
      pin_by: profile.username,
      count: bench_conversation.pins.size
    }
  end
end
