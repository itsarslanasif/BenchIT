class Profile < ApplicationRecord
  searchkick word_start: [:username, :description]

  def search_data
    {
      username: username,
      description: description,
      workspace_id: workspace_id,
    }
  end
  after_commit :add_default_image, on: %i[create]

  belongs_to :user
  belongs_to :workspace
  has_one_attached :profile_image, dependent: :destroy

  validates :username, presence: true
  validates :description, length: { maximum: 150 }

  has_many :saved_items
  has_many :conversation_messages, through: :saved_items

  enum role: {
    primary_owner: 0,
    workspace_owner: 1,
    workspace_admin: 2,
    member: 3
  }

  def add_default_image
    return if profile_image.attached?

    profile_image.attach(io: File.open(Rails.root.join(*%w[app assets images default_image.png])),
                 filename: 'default_image.png', content_type: 'image/png')
  end

end
