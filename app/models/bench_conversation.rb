class BenchConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :user, foreign_key: :sender_id, optional: true, inverse_of: :bench_conversations
  has_many :conversation_messages, dependent: :destroy

  scope :user_to_user_conversation, lambda { |sender_id, receiver_id|
    where(conversationable_type: 'User', sender_id: sender_id, conversationable_id: receiver_id)
  }
end
