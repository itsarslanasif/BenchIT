class BenchConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :sender, class_name: 'Profile', optional: true
  has_many :conversation_messages, dependent: :destroy
  has_many :draft_messages, dependent: :destroy

  enum status: {
    active: 0,
    disable: 1
  }

  scope :user_to_user_conversation, lambda { |sender_id, receiver_id|
    find_by(conversationable_type: 'Profile', sender_id: sender_id, conversationable_id: receiver_id) ||
      find_by(conversationable_type: 'Profile', sender_id: receiver_id, conversationable_id: sender_id) ||
      none
  }

  def self.last_dm_message
    BenchConversation.where(
      'conversationable_type = :conversationable_type AND (sender_id = :sender_id OR conversationable_id = :conversationable_id)',
      { conversationable_type: 'Profile', sender_id: Current.profile, conversationable_id: Current.profile }
    ).pluck(:id)
  end
end
