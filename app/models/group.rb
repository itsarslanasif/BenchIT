class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy

  validates :profile_ids, presence: true, length: { in: 2..9 }
  validates :profile_ids, inclusion: { in: Current.workspace.profile_ids }

  def name
    'group_name'
  end
end
