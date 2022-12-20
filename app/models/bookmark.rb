class Bookmark < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :bench_channel, optional: true
  belongs_to :profile

  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }
end
