class Bookmark < ApplicationRecord
  before_validation :set_profile
  after_commit :broadcast_bookmark

  belongs_to :bookmarkable, polymorphic: true
  belongs_to :profile

  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  scope :with_bookmarkable_id_and_type, lambda { |bookmarkable_id, bookmarkable_type|
    where(bookmarkable_id: bookmarkable_id, bookmarkable_type: bookmarkable_type)
  }

  private

  def broadcast_bookmark
    result = {
      content: bookmark_content,
      type: 'Bookmark'
    }
    result[:action] = if destroyed?
                        'Delete'
                      elsif created_at.eql?(updated_at)
                        'Create'
                      else
                        'Update'
                      end
    @conversation = case bookmarkable_type
                    when 'Profile'
                      BenchConversation.profile_to_profile_conversation(bookmarkable_id, profile_id)
                    else
                      bookmarkable.bench_conversation
                    end
    BroadcastMessageService.new(result, @conversation).call
  end

  def set_profile
    self.profile_id = Current.profile.id
  end

  def bookmark_content
    {
      id: id,
      name: name,
      url: bookmark_URL
    }
  end
end
