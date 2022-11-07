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
  belongs_to :identity
  has_one_attached :profile_image, dependent: :destroy
  validates :username, presence: true
  validates :description, length: { maximum: 150 }
end
