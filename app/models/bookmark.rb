class Bookmark < ApplicationRecord
  belongs_to :bookmarkable, polymorphic: true
  belongs_to :profile

  before_validation :set_profile
  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  scope :with_bookmarkable_id_and_type, lambda { |bookmarkable_id, bookmarkable_type|
    where(bookmarkable_id: bookmarkable_id, bookmarkable_type: bookmarkable_type)
  }

  private

  def set_profile
    self.profile_id = Current.profile.id
  end
end
