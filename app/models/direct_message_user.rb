class DirectMessageUser < ApplicationRecord
  belongs_to :profile
  validates :profile, uniqueness: { scope: %i[receiver_id] }

  scope :dm_profiles, lambda { |direct_message_users_ids|
                        Profile.where(id: Current.profile.direct_message_users.pluck(:receiver_id) & direct_message_users_ids) |
                          [Current.profile]
                      }
end
