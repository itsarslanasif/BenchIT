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
  after_commit :broadcast_profile

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
  has_many :recent_statuses, dependent: :destroy

  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :downloads, dependent: :destroy

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

  def broadcastable_content
    {
      content: profile_content,
      type: 'Profile',
      action: action_performed
    }
  end

  def broadcast_profile
    BroadcastMessageNotificationService.new(broadcastable_content, workspace.profile_ids).call
  end

  def action_performed
    if destroyed?
      'Delete'
    elsif created_at.eql?(updated_at)
      'Create'
    else
      'Update'
    end
  end

  def profile_content
    {
      id: id,
      username: username,
      description: description,
      workspace_id: workspace_id,
      user_id: user_id,
      display_name: display_name,
      pronounce_name: pronounce_name,
      role: role,
      title: title,
      status: text_status.present? ? { text: text_status, emoji: emoji_status, clear_after: clear_status_after } : nil,
      contact_info: { email: user.email, phone: phone },
      about_me: { skype: skype },
      local_time: Time.current.in_time_zone(time_zone).strftime('%I:%M %p')
    }
  end

  def update_profile(text_status, emoji_status, clear_status_after)
    update(text_status: text_status, emoji_status: emoji_status, clear_status_after: clear_status_after)
  end
  
  def get_favourite_id(favourable_id, favourable_type)
    Current.profile.favourites.find_by(favourable_type: favourable_type, favourable_id: favourable_id)&.id
  end
end
