class ScheduleMessage < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_conversation

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }
  validates :scheduled_at, presence: true
end
