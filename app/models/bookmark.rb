class Bookmark < ApplicationRecord
  after_commit :broadcast_bookmark

  belongs_to :bench_conversation

  validates :bookmark_URL, presence: true
  validates :name, length: { maximum: 50 }

  private

  def broadcast_bookmark
    result = {
      content: bookmark_content,
      type: 'Bookmark'
    }
    result[:action] = ActionPerformed.new.action_performed(self)
    BroadcastMessageChatService.new(result, bench_conversation).call
  end

  def bookmark_content
    {
      id: id,
      name: name,
      url: bookmark_URL
    }
  end
end
