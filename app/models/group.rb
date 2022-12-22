class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy

  scope :joined_groups, ->(id) { where('? = ANY (members)', id) }

  def name
    'group_name'
  end
end
