class DmList < ApplicationRecord
  belongs_to :profile
  validates :profile, uniqueness: { scope: %i[receiver_id] }
end
