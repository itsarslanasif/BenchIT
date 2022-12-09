class BenchConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :user, foreign_key: :sender_id, optional: true, inverse_of: :bench_conversations
  has_many :conversation_messages, dependent: :destroy

  scope :user_to_user_conversation, lambda { |sender_id, receiver_id|
    find_by(conversationable_type: 'User', sender_id: sender_id, conversationable_id: receiver_id) ||
      find_by(conversationable_type: 'User', sender_id: receiver_id, conversationable_id: sender_id) ||
      none
  }

  def self.last_dm_message
    BenchConversation.where(
      'conversationable_type = :conversationable_type AND (sender_id = :sender_id OR conversationable_id = :conversationable_id)',
      { conversationable_type: 'User', sender_id: Current.user, conversationable_id: Current.user }
    ).pluck(:id)
  end
end
