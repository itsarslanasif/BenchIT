class Reaction < ApplicationRecord
  include Cablable
  after_create :set_action_create
  after_update :set_action_update
  after_destroy :set_action_delete
  after_commit :reaction_broadcast

  belongs_to :profile
  belongs_to :conversation_message

  def reaction_broadcast
    reaction = set_reaction
    result = {
      content: reaction,
      action: @action,
      type: 'Reaction'
    }
    result = append_conversation_type_and_id(conversation_message.bench_conversation, result)
    BroadcastMessageService.new(result, conversation_message.bench_conversation).call
  end

  private

  def set_action_delete
    @action = 'Delete'
  end

  def set_action_create
    @action = 'Create'
  end

  def set_action_update
    @action = 'Update'
  end

  def set_reaction
    {
      id: id,
      emoji: emoji,
      conversation_message_id: conversation_message_id,
      bench_conversation_id: conversation_message.bench_conversation_id
    }
  end
end
