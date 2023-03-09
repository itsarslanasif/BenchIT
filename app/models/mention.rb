class Mention < ApplicationRecord
  belongs_to :conversation_message
  belongs_to :mentionable, polymorphic: true
end
