class Reaction < ApplicationRecord
  after_commit :reaction_broadcast

  belongs_to :profile
  belongs_to :conversation_message

  private

  def reaction_broadcast
    result = {
      content: reaction_content,
      type: 'Reaction'
    }
    result[:action] = if destroyed?
                        'Delete'
                      elsif created_at.eql?(updated_at)
                        'Create'
                      else
                        'Update'
                      end
    BroadcastMessageService.new(result, conversation_message.bench_conversation).call
  end

  def reaction_content
    {
      id: id,
      emoji: emoji,
      conversation_message_id: conversation_message_id,
      bench_conversation_id: conversation_message.bench_conversation_id,
      user_name: profile.username,
    }
  end
end
