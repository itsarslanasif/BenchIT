class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy
  #belongs_to :profile, foreign_key: :members, inverse_of: :conversation_messages

  scope :joined_groups, ->(id) { where("'#{id}' = ANY (members)") }

  def name
    'group_name'
  end
end
