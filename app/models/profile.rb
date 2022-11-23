class Profile < ApplicationRecord
  include Searchable
  
  after_commit :add_default_image, on: %i[create]

  belongs_to :user
  belongs_to :workspace
  has_one_attached :profile_image, dependent: :destroy

  validates :username, presence: true
  validates :description, length: { maximum: 150 }

  enum account_type: {
    all_types: 0,
    owners: 1,
    admins: 2,
    full_members: 3,
    guests: 4,
    deactivated_accounts: 5,
    not_on_slack: 6
  }

  scope :filter_by_account_type, -> (account_type) { where account_type: account_type }

  def add_default_image
    return if profile_image.attached?

    profile_image.attach(io: File.open(Rails.root.join(*%w[app assets images default_image.png])),
                 filename: 'default_image.png', content_type: 'image/png')
  end
end
