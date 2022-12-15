class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :profiles, dependent: :destroy
  has_many :workspaces, through: :profiles, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :draft_messages, dependent: :destroy

  paginates_per 10

  devise :invitable, :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates_presence_of :email
  has_many :channel_participants
  has_many :bench_channels, foreign_key: :creator_id, inverse_of: :user, through: :channel_participants
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :conversation_messages, dependent: :destroy, foreign_key: :sender_id, inverse_of: :user
  has_many :bench_conversations, as: :conversationable, foreign_key: :sender_id, inverse_of: :user
  has_many :schedule_messages, dependent: :destroy, foreign_key: :sender_id, inverse_of: :user

  scope :workspace_users, ->(workspace_id) { joins(:profiles).where(workspace_id: workspace_id).distinct }
end
