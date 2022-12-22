class ChannelParticipant < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_channel
  validates :permission, presence: true
end
