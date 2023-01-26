class ScheduleMessage < ApplicationRecord
  belongs_to :profile
  belongs_to :bench_conversation

  before_validation :change_time, on: :create
  after_create :set_job

  validates :content, presence: true, length: { minimum: 1 }
  validates :scheduled_at, presence: true
  validates :job_id, presence: true, on: :update
  #validate :schedule_date_after_current_date

  private

  def schedule_date_after_current_date
    return unless scheduled_at.in_time_zone(Current.profile.time_zone).to_time < Time.now.in_time_zone(Current.profile.time_zone).to_time

    errors.add(:scheduled_at,
               'must be after the current date.')
  end

  def set_job
    time = scheduled_at.in_time_zone(Current.profile.time_zone)
    job = ScheduleMessageJob.set(wait_until: time).perform_later(Current.profile.id, id)
    update!(job_id: job.provider_job_id)
  end

  def change_time
    self.scheduled_at = Time.zone.parse(self.scheduled_at).in_time_zone(Current.profile.time_zone)
  end
end
