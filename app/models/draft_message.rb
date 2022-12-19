class DraftMessage < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_conversation

  validates :content, presence: true
  validates :bench_conversation, uniqueness: { scope: [:profile] }
end
