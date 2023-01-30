class Workspace < ApplicationRecord
  include AvatarGeneration

  has_one_attached :workspace_avatar, dependent: :destroy

  has_many :profiles, dependent: :destroy
  has_many :users, through: :profiles, dependent: :destroy
  has_many :statuses
  has_many :bench_channels, dependent: :destroy

  validates :company_name, presence: true
  validates :bench_it_url, uniqueness: true, presence: true
  validates :capacity, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5000 }

  after_commit :attach_avatar, on: %i[create]

  enum workspace_type: {
    work: 0,
    school: 1,
    shared_interest: 2,
    other: 3
  }

  enum organization_type: {
    consumer_goods: 0,
    financial_services: 1,
    government: 2,
    healthCare_pharmacutical: 3,
    media: 4,
    non_profit: 5
  }

  enum admin_role: {
    administrative: 0,
    accounting: 1,
    business_development: 2,
    business_owner: 3,
    customer_support: 4
  }

  def attach_avatar
    self.generate_avatar(self.company_name, workspace_avatar)
  end
end
