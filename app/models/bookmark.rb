class Bookmark < ApplicationRecord
  belongs_to :bookmarkable, polymorphic: true

  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  scope :with_bookmarkid_and_bookmarktype, lambda { |bookmark_id, bookmark_type|
    where(bookmarkable_id: bookmark_id).where(bookmarkable_type: bookmark_type)
  }
end
