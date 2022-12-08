class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :favourable, polymorphic: true

  scope :already_favourite, -> (favourites_params) { find_by(favourites_params) }

end
