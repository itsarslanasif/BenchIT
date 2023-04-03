class Invitable < ApplicationRecord
  belongs_to :workspace
  belongs_to :profile
  belongs_to :acceptor, class_name: 'Profile', optional: true

  validates :email, :token, :status, presence: true
  validates :workspace, uniqueness: { scope: %i[email] }
  validates :token, uniqueness: true

  before_validation :set_values, on: :create

  enum invitation_type: { member: 0, guest: 1 }
  enum status: { pending: 0, approved: 1, rejected: 2, accepted: 3 }

  private

  def set_values
    self.workspace_id = Current.workspace.id
    self.profile_id = Current.profile.id
    self.token = SecureRandom.hex(32)
  end
end
