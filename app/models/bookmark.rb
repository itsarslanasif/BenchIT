class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bench_channel

  validates :bookmark_URL, presence: true
  validates :name,  length: {maximum: 50 }
end
