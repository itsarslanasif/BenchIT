class DraftMessage < ApplicationRecord
  belongs_to :user
  belongs_to :draftable, polymorphic: true
end
