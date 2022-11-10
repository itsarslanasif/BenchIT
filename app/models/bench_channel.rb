# == Schema Information
#
# Table name: bench_channels
#
#  id          :bigint           not null, primary key
#  description :text
#  is_private  :boolean          default(FALSE)
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :bigint
#
# Indexes
#
#  index_bench_channels_on_creator_id  (creator_id)
#  index_bench_channels_on_name        (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
class BenchChannel < ApplicationRecord
  belongs_to :user, foreign_key: :creator_id, inverse_of: :bench_channels
  has_many :channel_participants, dependent: :destroy
  has_many :users, through: :channel_participants
  has_one :bench_conversation, as: :conversationable, dependent: :destroy

  validates :name, uniqueness: true, presence: true, length: { minimum: 1, maximum: 80 }
  validates :description, length: { maximum: 500}
end
