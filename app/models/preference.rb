class Preference < ApplicationRecord
  include UuidGenerator

  belongs_to :profile
end
