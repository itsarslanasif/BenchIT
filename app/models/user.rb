class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :profiles, dependent: :destroy
  has_many :workspaces, through: :profiles, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  before_create :set_values

  scope :workspace_users, -> { joins(:profiles).where(workspace_id: Current.workspace).distinct }

  private

  def set_values
    self.jti = SecureRandom.uuid
    self.password = ENV.fetch('Password', 'Password1!') if password.blank?
    self.name = email.split('@').first if name.blank?
  end
end
