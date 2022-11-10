# == Schema Information
#
# Table name: bench_conversations
#
#  id                    :bigint           not null, primary key
#  conversationable_type :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  conversationable_id   :bigint
#  sender_id             :bigint
#
# Indexes
#
#  index_bench_conversations_on_sender_id        (sender_id)
#  index_chat_conversations_on_conversationable  (conversationable_type,conversationable_id)
#
# Foreign Keys
#
#  fk_rails_...  (sender_id => users.id)
#
class BenchConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :user, foreign_key: :sender_id, optional: true, inverse_of: :bench_conversations
  has_many :conversation_messages, dependent: :destroy
end
