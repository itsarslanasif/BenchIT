class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  before_validation :sort_ids

  validates :profile_ids, presence: true, length: { in: 2..9 }
  validates :profile_ids, inclusion: { in: Current.workspace.profile_ids }

  after_commit :broadcast_group

  def broadcast_group
    message = {
      type: 'Group',
      action: ActionPerformed.new.action_performed(self)
    }
    message[:content] = {
      id: id,
      name: name,
      profile_ids: profile_ids
    }

    BroadcastMessageNotificationService.new(message, profile_ids).call
  end

  def name
    Profile.where(id: profile_ids).pluck(:username).join(', ')
  end

  def sort_ids
    self.profile_ids = profile_ids.sort.uniq
  end
end
