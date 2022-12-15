class DraftMessage < ApplicationRecord
  belongs_to :user
  belongs_to :bench_conversation

  validates :content, presence: true
  validates :bench_conversation, uniqueness: { scope: [:user] }
end