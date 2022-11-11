class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  validates :username, presence: true
  validates :description, length: { maximum: 150 }
end
