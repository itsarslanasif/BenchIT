class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bench_channel
  before_validation :set_user

  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  private

  def set_user
    self.user_id = Current.user.id
  end
end
