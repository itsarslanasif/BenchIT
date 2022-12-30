class Reaction < ApplicationRecord
  include Cablable
  after_destroy :reaction_delete_broadcast
  after_save :reaction_broadcast

  belongs_to :profile
  belongs_to :conversation_message

  def reaction_broadcast
    result = append_conversation_type_and_id(conversation_message.bench_conversation, set_reaction)
    BroadcastMessageService.new(result, conversation_message.bench_conversation).call
  end

  def reaction_delete_broadcast
    result = set_reaction
    result[:action] = 'Delete'
    result = append_conversation_type_and_id(conversation_message.bench_conversation, result)
    BroadcastMessageService.new(result, conversation_message.bench_conversation).call
  end

  private

  def set_reaction
    reaction = {
      id: id,
      emoji: emoji,
      conversation_message_id: conversation_message_id,
      bench_conversation_id: conversation_message.bench_conversation_id
    }
    result = {
      content: reaction,
      type: 'Reaction'
    }
    result[:action] = created_at == updated_at ? 'Create' : 'Update'
    result
  end
end
