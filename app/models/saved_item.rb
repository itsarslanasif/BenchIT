class SavedItem < ApplicationRecord
  belongs_to :profile
  belongs_to :conversation_message
end
