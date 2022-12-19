class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

  paginates_per 10

  has_many :profiles, dependent: :destroy
  has_many :workspaces, through: :profiles, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reactions, dependent: :destroy

  validates_presence_of :email

  scope :workspace_users, ->(workspace_id) { joins(:profiles).where(workspace_id: workspace_id).distinct }
end
