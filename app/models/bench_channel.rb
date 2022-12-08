class BenchChannel < ApplicationRecord
  belongs_to :user, foreign_key: :creator_id, inverse_of: :bench_channels
  belongs_to :workspace
  has_many :channel_participants, dependent: :destroy
  has_many :users, through: :channel_participants
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  before_validation :set_user_and_workspace

  validates :name, uniqueness: true, presence: true, length: { minimum: 1, maximum: 80 }
  validates :description, length: { maximum: 500 }

  # Scopes
  scope :private_channels, ->(workspace_id) { where(is_private: true, workspace_id: workspace_id) }
  scope :public_channels, ->(workspace_id) { where(is_private: false, workspace_id: workspace_id) }
  scope :user_joined_private_channels, lambda { |user_id, workspace_id|
    joins(:channel_participants).where(
      'user_id = :user_id AND workspace_id = :workspace_id AND is_private = :is_private',
      { user_id: user_id, workspace_id: workspace_id, is_private: true }
    ).distinct
  }

  private

  def set_user_and_workspace
    self.creator_id = Current.user.id
    self.workspace_id = Current.workspace.id
  end
end
