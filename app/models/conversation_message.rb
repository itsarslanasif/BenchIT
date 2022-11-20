class ConversationMessage < ApplicationRecord
  belongs_to :bench_conversation
  belongs_to :user, foreign_key: :sender_id, inverse_of: :conversation_messages
  after_commit :message_creation

  has_many_attached :message_attachments, dependent: :purge_later

  has_many :replies, class_name: 'ConversationMessage', foreign_key: :parent_message_id

  belongs_to :parent_message, class_name: 'ConversationMessage', foreign_key: :parent_message_id, optional: true

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }

  def message_creation
    response = {
      id: self.id,
      content: self.content,
      is_threaded: self.is_threaded,
      parent_message_id: self.parent_message_id,
      sender_id: self.sender_id,
      sender_name: self.user.name,
      bench_conversation_id: self.bench_conversation_id,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
    ActionCable.server.broadcast("ChatChannel#{self.bench_conversation.conversationable_id}", {
      message: response
    })
  end
end
