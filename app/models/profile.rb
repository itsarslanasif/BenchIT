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
  has_one_attached :recording

  has_many :saved_items
  has_many :channel_participants, dependent: :destroy
  has_many :bench_channels, through: :channel_participants
  has_many :conversation_messages, dependent: :destroy, foreign_key: :sender_id, inverse_of: :profile
  has_many :bench_conversations, as: :conversationable, dependent: :destroy
  has_many :draft_messages, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :favourites, dependent: :destroy, inverse_of: :profile

  validates :username, presence: true
  validates :description, length: { maximum: 150 }
  validates :display_name, length: { maximum: 80 }
  validates :text_status, length: { maximum: 100 }
  validates :pronounce_name, length: { maximum: 20 }

  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  enum role: {
    primary_owner: 0,
    workspace_owner: 1,
    workspace_admin: 2,
    member: 3
  }

  scope :workspace_profiles, -> { where(workspace_id: Current.workspace).distinct }

  def attach_recording
    recording.map do |attachment|
      {
        attachment: attachment.blob,
        attachment_link: Rails.application.routes.url_helpers.rails_storage_proxy_url(attachment)
      }
    end
  end

  def attach_profile_image
    profile_image.map do |attachment|
      {
        attachment: attachment.blob,
        attachment_link: Rails.application.routes.url_helpers.rails_storage_proxy_url(attachment)
      }
    end
  end

  def add_default_image
    return if profile_image.attached?

    profile_image.attach(io: Rails.root.join(*%w[app assets images default_image.png]).open,
                         filename: 'default_image.png', content_type: 'image/png')
  end

  def groups
    Group.where('profile_ids @> ARRAY[?]::integer[]', [id])
  end
end
