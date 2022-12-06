class BenchConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :user, foreign_key: :sender_id, optional: true, inverse_of: :bench_conversations
  has_many :conversation_messages, dependent: :destroy

  scope :user_to_user_conversation, lambda { |sender_id, receiver_id|
    find_by(conversationable_type: 'User', sender_id: sender_id, conversationable_id: receiver_id) ||
    find_by(conversationable_type: 'User', sender_id: receiver_id, conversationable_id: sender_id) ||
    none
  }

  private

  def self.set_previous_dms
    current_user = User.first
    return BenchConversation.where(
      'conversationable_type = :conversationable_type AND (sender_id = :sender_id OR conversationable_id = :conversationable_id)',
      { conversationable_type: 'User', sender_id: current_user, conversationable_id: current_user }
    ).pluck(:id)
  end
end
