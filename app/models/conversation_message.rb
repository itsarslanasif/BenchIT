class ConversationMessage < ApplicationRecord
  belongs_to :bench_conversation
  belongs_to :user, foreign_key: :sender_id, inverse_of: :conversation_messages
  after_commit :message_creation

  has_many_attached :message_attachments, dependent: :purge_later

  has_many :replies, class_name: 'ConversationMessage', foreign_key: :parent_message_id

  belongs_to :parent_message, class_name: 'ConversationMessage', foreign_key: :parent_message_id, optional: true

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }

  def message_creation
    ActionCable.server.broadcast("ChatChannel#{self.bench_conversation.conversationable_id}", {
      message: self
    })
  end
end
