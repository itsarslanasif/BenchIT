class ChannelParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :bench_channel
  validates :permission, presence: true
end
