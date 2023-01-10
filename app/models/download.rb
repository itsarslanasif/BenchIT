class Download < ApplicationRecord
  belongs_to :profile
  has_one_attached :file
end
