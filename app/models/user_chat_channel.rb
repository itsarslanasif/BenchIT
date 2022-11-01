# == Schema Information
#
# Table name: user_chat_channels
#
#  id              :bigint           not null, primary key
#  left_on         :datetime
#  permission      :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chat_channel_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_user_chat_channels_on_chat_channel_id  (chat_channel_id)
#  index_user_chat_channels_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_channel_id => chat_channels.id)
#  fk_rails_...  (user_id => users.id)
#
class UserChatChannel < ApplicationRecord
  belongs_to :user
  belongs_to :chat_channel
  validates :permission, presence: true
end
