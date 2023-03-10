class Download < ApplicationRecord
  include UuidGenerator

  belongs_to :profile
end
