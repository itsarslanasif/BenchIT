class Favourite < ApplicationRecord
  belongs_to :profile
  belongs_to :favourable, polymorphic: true

  validates :profile, uniqueness: { scope: [:favourable_id, :favourable_type] }
end
