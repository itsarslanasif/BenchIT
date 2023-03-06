class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  validates :profile_ids, presence: true, length: { in: 2..9 }
  #validates :profile_ids, inclusion: { in: Current.workspace.profile_ids }

  def fetch_group_chat_name
    Profile.where(id: profile_ids).pluck(:username).join(',')
  end
end
