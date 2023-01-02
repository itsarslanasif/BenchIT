class Bookmark < ApplicationRecord
  include Cablable
  before_validation :set_profile
  after_create :set_action_create
  after_update :set_action_update
  after_destroy :set_action_delete
  after_commit :broadcast_bookmark

  belongs_to :bookmarkable, polymorphic: true
  belongs_to :profile

  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  scope :with_bookmarkable_id_and_type, lambda { |bookmarkable_id, bookmarkable_type|
    where(bookmarkable_id: bookmarkable_id, bookmarkable_type: bookmarkable_type)
  }

  def broadcast_bookmark
    result = {
      content: set_bookmark,
      action: @action,
      type: 'Bookmark'
    }
    result = append_conversation_type_and_id(@conversation, result)
    BroadcastMessageService.new(result, @conversation).call
  end

  private

  def set_profile
    self.profile_id = Current.profile.id
  end

  def set_action_delete
    @action = 'Delete'
  end

  def set_action_create
    @action = 'Create'
  end

  def set_action_update
    @action = 'Update'
  end

  def set_bookmark
    bookmark = {
      id: id,
      name: name,
      url: bookmark_URL
    }
    bookmark_conversation
    bookmark
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
