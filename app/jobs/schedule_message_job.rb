class ScheduleMessageJob < ApplicationJob
  queue_as :default

  def perform(profile_id, schedule_id)
    Current.profile = Profile.find(profile_id)
    Current.workspace = Current.profile.workspace
    @schedule = ScheduleMessage.find_by(id: schedule_id)
    send_message unless @schedule.nil?
  end

  private

  def send_message
    ActiveRecord::Base.transaction do
      Current.profile.conversation_messages.create!(content: @schedule.content, bench_conversation_id: @schedule.bench_conversation_id)
      @schedule.destroy!
    end
  end
end
