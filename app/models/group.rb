# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_one :bench_conversation, as: :conversationable

end
