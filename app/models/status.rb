class Status < ApplicationRecord
  belongs_to :profile, optional: true
  belongs_to :workspace, optional: true
end
