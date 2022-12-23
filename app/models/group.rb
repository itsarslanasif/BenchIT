class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  def name
    'group_name'
  end
end
