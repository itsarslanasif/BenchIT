class Invitable < ApplicationRecord
  belongs_to :workspace
  belongs_to :profile

  validates :email, :token, presence: true
  validates :status, presence: true # , numericality: { only_integer: true, inclusion: 0..3 }
  validates :invitation_type, presence: true # , numericality: { only_integer: true, inclusion: 0..1 }
  validates :workspace, uniqueness: { scope: %i[email] }

  before_validation :set_values, on: :create

  enum invitation_type: { member: 0, guest: 1 }
  enum status: { pending: 0, approved: 1, rejected: 2, accepted: 3 }
  enum has_account: { yes: 0, no: 1 }

  private

  def set_values
    self.workspace_id = Current.workspace.id
    self.profile_id = Current.profile.id
    self.token = SecureRandom.hex(32)
  end
end
