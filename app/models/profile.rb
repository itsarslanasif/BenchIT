# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  description  :text
#  username     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  identity_id  :bigint           not null
#  workspace_id :bigint           not null
#
# Indexes
#
#  index_profiles_on_identity_id                   (identity_id)
#  index_profiles_on_workspace_id_and_identity_id  (workspace_id,identity_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (identity_id => identities.id)
#
class Profile < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :identity
  has_one_attached :profile_image, dependent: :destroy
  validates :username, presence: true
  validates :description, length: { maximum: 150 }

  after_commit :add_default_image, on: %i[create]

  def add_default_image
    return if profile_image.attached?

    profile_image.attach(io: File.open(Rails.root.join(*%w[app assets images default_image.png])),
                 filename: 'default_image.png', content_type: 'image/png')
  end

  def image_url
    url_for(profile_image) if profile_image.attached?
  end
end
