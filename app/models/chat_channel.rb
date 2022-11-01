# == Schema Information
#
# Table name: chat_channels
#
#  id          :bigint           not null, primary key
#  description :text
#  is_private  :boolean          default(FALSE)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :bigint
#
# Indexes
#
#  index_chat_channels_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
class ChatChannel < ApplicationRecord


  belongs_to :user, foreign_key: :creator_id


  #belongs_to :workspace
  has_many :user_chat_channels
  has_many :users, through: :user_chat_channels
  has_one :chat_conversation, as: :conversationable

  validates :name, uniqueness: true, presence: true, length: { minimum: 1, maximum: 80 }
  validates :description, length: { minimum: 1, maximum: 10 }
  #validates :is_private, presence: true

end
