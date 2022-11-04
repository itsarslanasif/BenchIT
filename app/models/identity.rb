# == Schema Information
#
# Table name: identities
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Identity < ApplicationRecord
  has_many :profiles, dependent: :destroy
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
