class Bookmark < ApplicationRecord
  belongs_to :bookmarkable, polymorphic: true
  belongs_to :profile

  before_validation :set_profile
  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  scope :with_bookmarkid_and_bookmarktype, lambda { |bookmark_id, bookmark_type|
    where(bookmarkable_id: bookmark_id, bookmarkable_type: bookmark_type)
  }

  private

  def set_profile
    self.profile_id = Current.profile.id
  end
end
