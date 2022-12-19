class Favourite < ApplicationRecord
  belongs_to :profile
  belongs_to :favourable, polymorphic: true
end
