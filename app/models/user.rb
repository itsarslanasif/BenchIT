class User < ApplicationRecord
  paginates_per 10

  devise :invitable, :database_authenticatable

  validates_presence_of :email
end
