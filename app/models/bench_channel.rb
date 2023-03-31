class BenchChannel < ApplicationRecord
  belongs_to :creator, class_name: 'Profile'
  belongs_to :workspace
  has_many :channel_participants, dependent: :destroy
  has_many :profiles, through: :channel_participants
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy
  has_many :mentions, as: :mentionable, dependent: :destroy
  has_many :bookmarks, through: :bench_conversation
  has_many :bookmark_folders, through: :bench_conversation

  before_validation :set_profile_and_workspace
  before_validation :set_lower_case_channel_name
  after_commit :broadcast_channel, on: :update

  validates :name, presence: true, length: { minimum: 1, maximum: 80 }
  validates :name, uniqueness: { scope: %i[workspace_id] }
  validates :description, length: { maximum: 500 }

  scope :private_channels, -> { where(is_private: true, workspace_id: Current.workspace) }
  scope :public_channels, -> { where(is_private: false, workspace_id: Current.workspace) }
  scope :profile_joined_private_channels, lambda {
    joins(:channel_participants).where(
      'profile_id = :profile_id AND workspace_id = :workspace_id AND is_private = :is_private',
      { profile_id: Current.profile, workspace_id: Current.workspace, is_private: true }
    ).distinct
  }
  scope :get_private_channels, lambda {
    where(is_private: true).joins(:channel_participants).where(channel_participants: { profile: Current.profile })
  }
  scope :get_public_channels, lambda {
    where(is_private: false)
  }
  scope :hide_participated_channels, lambda { |ids|
    where(is_private: false).where.not(id: ids)
  }

  searchkick word_start: [:name, :description]
  def search_data
    {
      name: name,
      description: description,
      workspace_id: workspace_id
    }
  end

  def participant?(profile)
    channel_participants.exists?(profile: profile)
  end

  def self.reject_unjoined_privated_channels(bench_channels)
    @bench_channels = bench_channels.reject do |channel|
      channel.is_private && !channel.participant?(Current.profile)
    end

    @bench_channels = BenchChannel.where(id: @bench_channels.map(&:id))
  end

  def bench_channel_content
    profiles.each_with_object(bench_channel_basic_content) do |profile, content|
      content[:profiles] << profile.profile_content
    end
  end

  private

  def set_profile_and_workspace
    self.creator_id = Current.profile.id
    self.workspace_id = Current.workspace.id
  end

  def set_lower_case_channel_name
    name.downcase!
  end

  def bench_channel_basic_content
    {
      id: id,
      name: name,
      description: description,
      creator_id: creator_id,
      created_at: created_at,
      updated_at: updated_at,
      is_private: is_private,
      creator_name: creator.username,
      profiles: []
    }
  end

  def broadcast_channel
    result = {
      content: bench_channel_basic_content,
      type: 'BenchChannel'
    }
    result[:action] = ActionPerformed.new.action_performed(self)
    BroadcastMessageChatService.new(result, bench_conversation).call
  end
end
