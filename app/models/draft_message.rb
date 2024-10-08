class DraftMessage < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_conversation
  belongs_to :conversation_message, optional: true

  has_many_attached :message_attachments, dependent: :purge_later

  validates :content, presence: true, length: { minimum: 1 }
  validates :profile, uniqueness: { scope: %i[bench_conversation_id conversation_message_id] }

  scope :get_draft_message, lambda { |conversation_id, message_id|
    find_by(conversation_message_id: message_id, profile_id: Current.profile.id, bench_conversation_id: conversation_id) ||
      none
  }
end
