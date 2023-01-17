class ChannelParticipant < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_channel

  validates :permission, presence: true
  validates :bench_channel, uniqueness: { scope: [:profile] }
end
