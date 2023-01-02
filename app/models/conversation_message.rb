class ConversationMessage < ApplicationRecord
  include Cablable
  after_create :set_action_create
  after_update :set_action_update
  after_destroy :set_action_delete
  after_commit :broadcast_message

  belongs_to :bench_conversation
  belongs_to :profile, foreign_key: :sender_id, inverse_of: :conversation_messages
  belongs_to :parent_message, class_name: 'ConversationMessage', optional: true

  has_many_attached :message_attachments, dependent: :purge_later

  has_many :replies, class_name: 'ConversationMessage',
                     foreign_key: :parent_message_id, dependent: :destroy
  has_many :saved_items
  has_many :reactions, dependent: :destroy
  has_one :pin, dependent: :destroy

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }

  scope :messages_by_ids_array, lambda { |ids|
    joins(:bench_conversation)
      .where(id: ids)
      .group(:conversationable_type, :conversationable_id, :id)
      .order(
        conversationable_type: :asc, conversationable_id: :asc, created_at: :desc
      )
  }

  scope :chat_messages, lambda { |id|
    where(parent_message_id: nil, bench_conversation_id: id).includes(:profile, :replies, :reactions).with_attached_message_attachments
  }

  def self.recent_last_conversation(conversation_ids)
    two_weaks_ago_time = DateTimeLibrary.new.two_weeks_ago_time
    ConversationMessage.where(bench_conversation_id: conversation_ids).where('created_at > ?',
                                                                             two_weaks_ago_time).distinct.pluck(:bench_conversation_id)
  end

  private

  def set_action_delete
    @action = 'Delete'
  end

  def set_action_create
    @action = 'Create'
  end

  def set_action_update
    @action = 'Update'
  end

  def broadcast_message
    result = {
      content: set_message,
      action: @action,
      type: 'Message'
    }
    result = append_conversation_type_and_id(bench_conversation, result)
    BroadcastMessageService.new(result, bench_conversation).call
  end

  def attach_message_attachments
    message_attachments.map do |attachment|
      {
        attachment: attachment.blob,
        attachment_link: Rails.application.routes.url_helpers.rails_storage_proxy_url(attachment),
        attachment_download_link: Rails.application.routes.url_helpers.rails_blob_url(attachment,
                                                                                      disposition: 'attachment')
      }
    end
  end

  def saved?(message)
    Current.profile.saved_items.exists?(conversation_message_id: message.id)
  end

  def set_message
    message = {
      id: id,
      content: content,
      is_threaded: is_threaded,
      is_edited: created_at != updated_at,
      parent_message_id: parent_message_id,
      sender_id: sender_id,
      sender_name: profile.username,
      reactions: reactions,
      created_at: created_at,
      updated_at: updated_at,
      isSaved: saved?(self),
      replies: replies,
      bench_conversation_id: bench_conversation_id,
      conversationable_type: bench_conversation.conversationable_type,
      conversationable_id: bench_conversation.conversationable_id
    }
    message[:attachments] = attach_message_attachments if message_attachments.present?
    message
  end
end
