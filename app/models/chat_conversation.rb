# == Schema Information
#
# Table name: chat_conversations
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
#  index_chat_conversations_on_conversationable  (conversationable_type,conversationable_id)
#  index_chat_conversations_on_sender_id         (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (sender_id => users.id)
#
class ChatConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :user, foreign_key: :sender_id, optional: true


  has_many :chat_messages
end
