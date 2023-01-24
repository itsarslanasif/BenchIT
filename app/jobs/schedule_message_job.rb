class ScheduleMessageJob < ApplicationJob
  queue_as :default

  def perform(profile_id, schedule_id)
    Current.profile = Profile.find(profile_id)
    Current.workspace = Current.profile.workspace
    schedule = ScheduleMessage.find(schedule_id)
    ConversationMessage.create!(content: schedule.content, bench_conversation_id: schedule.bench_conversation_id, sender_id: profile_id)
    schedule.destroy!
  end
end
