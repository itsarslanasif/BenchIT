class Profile < ApplicationRecord
  searchkick word_start: [:username, :description]

  def search_data
    {
      user_id: user_id,
      username: username,
      description: description,
      workspace_id: workspace_id
    }
  end

  after_commit :add_default_image, on: %i[create]

  belongs_to :user
  belongs_to :workspace

  has_one_attached :profile_image, dependent: :destroy

  has_many :saved_items
  has_many :channel_participants, dependent: :destroy
  has_many :bench_channels, through: :channel_participants
  has_many :conversation_messages, dependent: :destroy, foreign_key: :sender_id, inverse_of: :profile
  has_many :bench_conversations, as: :conversationable, dependent: :destroy
  has_many :draft_messages, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :favourites, dependent: :destroy, inverse_of: :profile
  #has_many :groups, dependent: :destroy, foreign_key: :members, inverse_of: :profile

  validates :username, presence: true
  validates :description, length: { maximum: 150 }

  enum role: {
    primary_owner: 0,
    workspace_owner: 1,
    workspace_admin: 2,
    member: 3
  }

  scope :workspace_profiles, -> { where(workspace_id: Current.workspace).distinct }

  def add_default_image
    return if profile_image.attached?

    profile_image.attach(io: Rails.root.join(*%w[app assets images default_image.png]).open,
                         filename: 'default_image.png', content_type: 'image/png')
  end
end
