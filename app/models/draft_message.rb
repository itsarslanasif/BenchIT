class DraftMessage < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_conversation
  belongs_to :conversation_message, optional: true

  validates :content, presence: true, length: { minimum: 1 }
  validates :profile, uniqueness: { scope: %i[bench_conversation_id conversation_message_id] }
end
