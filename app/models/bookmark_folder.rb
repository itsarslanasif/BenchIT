class BookmarkFolder < ApplicationRecord
  after_commit :broadcast_bookmark_folder

  belongs_to :bench_conversation
  has_many :bookmarks, dependent: :destroy

  validates :name, presence: true

  private

  def broadcast_bookmark_folder
    result = {
      content: bookmark_folder_content,
      type: 'BookmarkFolder'
    }
    result[:action] = ActionPerformed.new.action_performed(self)
    BroadcastMessageChatService.new(result, bench_conversation).call
  end

  def bookmark_folder_content
    {
      id: id,
      name: name
    }
  end
end
