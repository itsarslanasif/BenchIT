class Profile < ApplicationRecord
  after_commit :add_default_image, on: %i[create]
  
  belongs_to :user
  belongs_to :workspace
  has_one_attached :profile_image, dependent: :destroy

  validates :username, presence: true
  validates :description, length: { maximum: 150 }


  def add_default_image
    return if profile_image.attached?

    profile_image.attach(io: File.open(Rails.root.join(*%w[app assets images default_image.png])),
                 filename: 'default_image.png', content_type: 'image/png')
  end
end
