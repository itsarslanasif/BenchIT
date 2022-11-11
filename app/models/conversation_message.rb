class ConversationMessage < ApplicationRecord
  belongs_to :bench_conversation
  belongs_to :user, foreign_key: :sender_id, inverse_of: :conversation_messages

  has_many_attached :message_attachments, dependent: :purge_later

  has_many :replies, class_name: 'ConversationMessage', foreign_key: :parent_message_id

  belongs_to :parent_message, class_name: 'ConversationMessage', optional: true

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }
end
