class Reaction < ApplicationRecord
  include Cablable
  after_destroy :reaction_delete_broadcast
  after_save :reaction_broadcast

  belongs_to :profile
  belongs_to :conversation_message

  def reaction_broadcast
    set_reaction
    cable_channel_broadcast(conversation_message.bench_conversation, @result)
  end

  def reaction_delete_broadcast
    set_reaction
    @result[:action] = 'Delete'
    cable_channel_broadcast(conversation_message.bench_conversation, @result)
  end

  private

  def set_reaction
    reaction = {
      id: id,
      emoji: emoji,
      conversation_message_id: conversation_message_id,
      bench_conversation_id: conversation_message.bench_conversation_id
    }
    @result = {
      content: reaction,
      type: 'Reaction'
    }
    @result[:action] = created_at == updated_at ? 'Create' : 'Update'
  end
end
