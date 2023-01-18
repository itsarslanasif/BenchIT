class ConversationMessage < ApplicationRecord
  after_commit :add_unread_messages, :notify_profiles, :broadcast_message

  belongs_to :bench_conversation
  belongs_to :profile, foreign_key: :sender_id, inverse_of: :conversation_messages
  belongs_to :parent_message, class_name: 'ConversationMessage', optional: true

  has_many_attached :message_attachments, dependent: :purge_later

  has_many :replies, class_name: 'ConversationMessage',
                     foreign_key: :parent_message_id, dependent: :delete_all
  has_many :saved_items, dependent: :delete_all
  has_many :reactions, dependent: :delete_all
  has_one :pin, dependent: :destroy

  # validates :content, presence: true, length: { minimum: 1, maximum: 100 }

  scope :messages_by_ids_array, lambda { |ids|
    includes(:reactions, :replies, :parent_message, :saved_items)
      .with_attached_message_attachments
      .where(id: ids)
  }

  scope :chat_messages, lambda { |id|
    includes(:profile, :replies, :reactions).where(parent_message_id: nil,
                                                   bench_conversation_id: id).order(id: :desc).with_attached_message_attachments
  }

  def self.recent_last_conversation(conversation_ids)
    two_weaks_ago_time = DateTimeLibrary.new.two_weeks_ago_time
    ConversationMessage.where(bench_conversation_id: conversation_ids).where('created_at > ?',
                                                                             two_weaks_ago_time).distinct.pluck(:bench_conversation_id)
  end

  def message_content
    message = model_basic_content
    message[:pin] = { id: pin.id, pinned_by: pin.profile.username } if pin.present?
    message[:sender_avatar] = Rails.application.routes.url_helpers.rails_storage_proxy_url(profile.profile_image) if profile.profile_image.present?
    message[:attachments] = attach_message_attachments if message_attachments.present?

    message
  end

  private

  def broadcastable_content
    {
      content: message_content,
      type: 'Message',
      action: action_performed
    }
  end

  def broadcast_message
    BroadcastMessageService.new(broadcastable_content, bench_conversation).call
  end

  def action_performed
    if destroyed?
      'Delete'
    elsif created_at.eql?(updated_at)
      'Create'
    else
      'Update'
    end
  end

  def eligible_for_notification_profile_ids
    case bench_conversation.conversationable_type
    when 'Profile'
      [bench_conversation.conversationable_id, bench_conversation.sender_id]
    else
      bench_conversation.conversationable.profile_ids
    end
  end

  def notify_profiles
    return if action_performed.eql?('Update')

    BroadcastMessageService.new(broadcastable_content, bench_conversation)
                           .send_notification_ws(eligible_for_notification_profile_ids)
  end

  def add_unread_messages
    return unless action_performed.eql?('Create')

    UnreadMessagesCreatorService.new(bench_conversation, eligible_for_notification_profile_ids, id).call
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

  def model_basic_content
    {
      id: id, content: content,
      is_threaded: is_threaded,
      is_edited: created_at != updated_at,
      parent_message_id: parent_message_id,
      sender_id: sender_id,
      sender_name: profile.username,
      reactions: reactions,
      created_at: created_at,
      updated_at: updated_at,
      isSaved: false,
      pinned: pin.present?,
      replies: replies,
      bench_conversation_id: bench_conversation_id,
      conversationable_type: bench_conversation.conversationable_type,
      conversationable_id: bench_conversation.conversationable_id,
      is_info: is_info
    }
  end

  def saved?(id)
    Current.profile.saved_items.exists?(conversation_message_id: id)
  end
end
