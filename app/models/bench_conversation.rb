class BenchConversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :sender, class_name: 'Profile', optional: true
  has_many :conversation_messages, dependent: :destroy
  has_many :reactions, through: :conversation_messages
  has_many :draft_messages, dependent: :destroy
  has_many :pins, dependent: :destroy
  has_many :schedule_messages, dependent: :destroy

  validates :sender, uniqueness: { scope: %i[conversationable_id conversationable_type] }

  scope :profile_to_profile_conversation, lambda { |sender_id, receiver_id|
    find_by(conversationable_type: 'Profile', sender_id: sender_id, conversationable_id: receiver_id) ||
      find_by(conversationable_type: 'Profile', sender_id: receiver_id, conversationable_id: sender_id) ||
      none
  }

  def self.previous_or_create_new_profile_conversation(receiver_id)
    conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, receiver_id)

    return conversation if conversation.present?

    BenchConversation.create(conversationable_type: 'Profile', conversationable_id: receiver_id, sender_id: Current.profile.id)
  end

  def self.recent_conversation_ids
    BenchConversation.where(
      'conversationable_type = :conversationable_type AND (sender_id = :sender_id OR conversationable_id = :conversationable_id)',
      { conversationable_type: 'Profile', sender_id: Current.profile, conversationable_id: Current.profile }
    ).pluck(:id)
  end

  %w[profile bench_channel group].each do |type|
    define_method("#{type}?") do
      conversationable_type.eql?(type.camelcase)
    end
  end
end
