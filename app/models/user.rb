class User < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :workspaces, through: :profiles, dependent: :destroy

  paginates_per 10

  devise :invitable, :database_authenticatable

  validates_presence_of :email

  has_many :user_bench_channels
  has_many :bench_channels, through: :channel_participants
  has_many :bench_channels, foreign_key: :creator_id, inverse_of: :user
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :bench_conversations, foreign_key: :sender_id, inverse_of: :user
  has_many :conversation_messages, dependent: :destroy, foreign_key: :sender_id, inverse_of: :user
  has_many :bench_conversations, as: :conversationable
end
