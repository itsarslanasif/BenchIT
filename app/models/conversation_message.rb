# == Schema Information
#
# Table name: conversation_messages
#
#  id                    :bigint           not null, primary key
#  content               :text             not null
#  is_threaded           :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  bench_conversation_id :bigint
#  parent_message_id     :bigint
#  sender_id             :bigint
#
# Indexes
#
#  index_conversation_messages_on_bench_conversation_id  (bench_conversation_id)
#  index_conversation_messages_on_parent_message_id      (parent_message_id)
#  index_conversation_messages_on_sender_id              (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (bench_conversation_id => bench_conversations.id)
#  fk_rails_...  (sender_id => users.id)
#
class ConversationMessage < ApplicationRecord
  belongs_to :bench_conversation
  belongs_to :user, foreign_key: :sender_id, inverse_of: :conversation_messages
  has_many_attached :message_attachments, dependent: :purge_later
  has_many :replies, class_name: 'ConversationMessage', foreign_key: :parent_message_id
  belongs_to :parent_message, class_name: 'ConversationMessage', foreign_key: :parent_message_id, optional: true

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }

end
