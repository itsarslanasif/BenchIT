class Api::V1::ScheduleMessagesController < Api::ApiController
  def index
    @messages = Current.profile.schedule_messages.includes(:bench_conversation, :profile)
  end
end
