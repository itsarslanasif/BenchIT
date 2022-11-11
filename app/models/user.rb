class User < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :workspaces, through: :profiles, dependent: :destroy

  paginates_per 10

  devise :invitable, :database_authenticatable

  validates_presence_of :email

end
