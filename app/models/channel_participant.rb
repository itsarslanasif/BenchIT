# == Schema Information
#
# Table name: channel_participants
#
#  id               :bigint           not null, primary key
#  left_on          :datetime
#  permission       :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bench_channel_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_channel_participants_on_bench_channel_id  (bench_channel_id)
#  index_channel_participants_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (bench_channel_id => bench_channels.id)
#  fk_rails_...  (user_id => users.id)
#
class ChannelParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :bench_channel
  validates :permission, presence: true
end
