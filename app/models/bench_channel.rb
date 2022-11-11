class BenchChannel < ApplicationRecord
  belongs_to :user, foreign_key: :creator_id, inverse_of: :bench_channels
  has_many :channel_participants, dependent: :destroy
  has_many :users, through: :channel_participants
  has_one :bench_conversation, as: :conversationable, dependent: :destroy

  validates :name, uniqueness: true, presence: true, length: { minimum: 1, maximum: 80 }
  validates :description, length: { maximum: 500 }

  # Scopes
  scope :private_channels, -> { where(is_private: true) }
  scope :public_channels, -> { where(is_private: false) }
  scope :user_joined_private_channels, lambda { |user_id|
    joins(:channel_participants).where("user_id = #{user_id} AND is_private = true").distinct
  }
end
