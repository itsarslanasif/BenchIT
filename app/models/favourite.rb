class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :favourable, polymorphic: true
end
