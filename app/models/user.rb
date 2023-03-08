class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include UuidGenerator

  devise :invitable, :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

  paginates_per 10

  before_create :set_id

  has_many :profiles, dependent: :destroy
  has_many :workspaces, through: :profiles, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  scope :workspace_users, -> { joins(:profiles).where(workspace_id: Current.workspace).distinct }

  private

  def set_id
    generate_and_append_uuid(self)
  end
end
