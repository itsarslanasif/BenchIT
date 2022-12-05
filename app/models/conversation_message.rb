class ConversationMessage < ApplicationRecord
  belongs_to :bench_conversation
  belongs_to :user, foreign_key: :sender_id, inverse_of: :conversation_messages
  after_commit :broadcast_message

  has_many_attached :message_attachments, dependent: :purge_later

  has_many :replies, class_name: 'ConversationMessage', foreign_key: :parent_message_id

  has_many :reactions, dependent: :destroy

  belongs_to :parent_message, class_name: 'ConversationMessage', foreign_key: :parent_message_id, optional: true

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }

  def broadcast_message
    message = {
      id: id,
      content: content,
      is_threaded: is_threaded,
      parent_message_id: parent_message_id,
      sender_id: sender_id,
      sender_name: user.name,
      bench_conversation_id: bench_conversation_id,
      created_at: created_at,
      updated_at: updated_at
    }

    channel_key = "ChatChannel#{self.bench_conversation.conversationable_type}#{bench_conversation.conversationable_id}"
    channel_key += "-#{bench_conversation.sender_id}" if bench_conversation.conversationable_type.eql?('User')

    ActionCable.server.broadcast(channel_key, { message: message })
  end

  def self.set_previous_dms(conversation_ids)
    two_weaks_ago_time = DateTimeLibrary.new.get_two_weeks_ago_time
    return ConversationMessage.where(bench_conversation_id: conversation_ids).where("created_at > ?", two_weaks_ago_time).distinct.pluck(:bench_conversation_id)
  end
end
