class ConversationMessage < ApplicationRecord
  include Cablable
  after_destroy :broadcast_delete_message
  after_commit :broadcast_message, on: [:create, :update]

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

  def self.recent_last_conversation(conversation_ids)
    two_weaks_ago_time = DateTimeLibrary.new.two_weeks_ago_time
    ConversationMessage.where(bench_conversation_id: conversation_ids).where('created_at > ?',
                                                                             two_weaks_ago_time).distinct.pluck(:bench_conversation_id)
  end

  private

  def broadcast_message
    result = append_conversation_type_and_id(bench_conversation, set_message)
    BroadcastMessageService.new(result, bench_conversation).call
  end

  def broadcast_delete_message
    result = set_message
    result[:action] = 'Delete'
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

  def set_message
    message = {
      id: id,
      content: content,
      is_threaded: is_threaded,
      parent_message_id: parent_message_id,
      sender_id: sender_id,
      sender_name: profile.username,
      bench_conversation_id: bench_conversation_id,
      created_at: created_at,
      updated_at: updated_at,
      is_edited: created_at != updated_at
    }
    message[:attachments] = attach_message_attachments if message_attachments.present?
    result = {
      content: message,
      type: 'Message'
    }
    result[:action] = created_at == updated_at ? 'Create' : 'Update'
    result
  end
end
