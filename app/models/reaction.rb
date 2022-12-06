class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :conversation_message
end
