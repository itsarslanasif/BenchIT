class BenchConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :user, foreign_key: :sender_id, optional: true, inverse_of: :bench_conversations
  has_many :conversation_messages, dependent: :destroy
end
