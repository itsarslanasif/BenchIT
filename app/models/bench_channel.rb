class BenchChannel < ApplicationRecord
  belongs_to :creator, class_name: 'Profile'
  belongs_to :workspace
  has_many :channel_participants, dependent: :destroy
  has_many :profiles, through: :channel_participants
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_one :favourite, as: :favourable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  before_validation :set_profile_and_workspace

  validates :name, uniqueness: true, presence: true, length: { minimum: 1, maximum: 80 }
  validates :description, length: { maximum: 500 }

  scope :private_channels, -> { where(is_private: true, workspace_id: Current.workspace) }
  scope :public_channels, -> { where(is_private: false, workspace_id: Current.workspace) }
  scope :profile_joined_private_channels, lambda {
    joins(:channel_participants).where(
      'profile_id = :profile_id AND workspace_id = :workspace_id AND is_private = :is_private',
      { profile_id: Current.profile, workspace_id: Current.workspace, is_private: true }
    ).distinct
  }

  searchkick word_start: [:name, :description]
  def search_data
    {
      name: name,
      description: description,
      workspace_id: workspace_id
    }
  end

  def participating?(profile)
    channel_participants.exists?(profile: profile)
  end

  private

  def set_profile_and_workspace
    self.creator_id = Current.profile.id
    self.workspace_id = Current.workspace.id
  end
end
