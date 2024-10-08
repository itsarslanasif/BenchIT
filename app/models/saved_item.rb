class SavedItem < ApplicationRecord
  belongs_to :profile
  belongs_to :conversation_message

  validates :profile, uniqueness: { scope: %i[conversation_message_id] }
end
