class Bookmark < ApplicationRecord
  include Cablable
  after_destroy :broadcast_delete_bookmark
  after_save :broadcast_bookmark

  belongs_to :bookmarkable, polymorphic: true
  belongs_to :profile

  before_validation :set_profile
  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  scope :with_bookmarkable_id_and_type, lambda { |bookmarkable_id, bookmarkable_type|
    where(bookmarkable_id: bookmarkable_id, bookmarkable_type: bookmarkable_type)
  }

  def broadcast_bookmark
    set_bookmark
    cable_channel_broadcast(@conversation, @result)
  end

  def broadcast_delete_bookmark
    set_bookmark
    @result[:action] = 'Delete'
    cable_channel_broadcast(@conversation, @result)
  end

  private

  def set_profile
    self.profile_id = Current.profile.id
  end

  def set_bookmark
    bookmark = {
      id: id,
      name: name,
      url: bookmark_URL
    }
    @result = {
      content: bookmark,
      type: 'Bookmark'
    }
    @result[:action] = created_at == updated_at ? 'Create' : 'Update'
    bookmark_conversation
  end

  def bookmark_conversation
    @conversation = case bookmarkable_type
                    when 'Profile'
                      BenchConversation.profile_to_profile_conversation(bookmarkable_id, profile_id)
                    else
                      bookmarkable.bench_conversation
                    end
  end
end
