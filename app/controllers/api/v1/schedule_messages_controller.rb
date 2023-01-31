class Api::V1::ScheduleMessagesController < Api::ApiController
  include MemberShip

  before_action :set_schedule_message, :authenticate_message, only: %i[destroy update send_now]

  def index
    @messages = Current.profile.schedule_messages.includes(:bench_conversation, :profile).order(created_at: :desc)
  end

  def update
    @schedule_message.update!(schedule_message_params)
    if params[:scheduled_at].present?
      delete_job
      reschedule_job
    end
    render json: { success: true, message: 'Message updated' }, status: :ok
  end

  def destroy
    delete_job
    @schedule_message.destroy!
    render json: { success: true, message: 'Message deleted' }, status: :ok
  end

  def send_now
    ActiveRecord::Base.transaction do
      delete_job
      Current.profile.conversation_messages.create!(content: @schedule_message.content,
                                                    bench_conversation_id: @schedule_message.bench_conversation_id)
      @schedule_message.destroy!
    end
    render json: { success: true, message: 'Message send' }, status: :ok
  end

  private

  def schedule_message_params
    params[:scheduled_at] = params[:schedule] if params[:schedule].present?
    params.permit(:content, :scheduled_at).tap do |param|
      param[:profile_id] = Current.profile.id
    end
  end

  def set_schedule_message
    @schedule_message = ScheduleMessage.find(params[:id])
  end

  def authenticate_message
    if @schedule_message.profile_id.eql?(Current.profile.id)
      check_membership(@schedule_message.bench_conversation)
    else
      render json: { error: 'Sorry, this message is not yours.' }, status: :unauthorized
    end
  end

  def delete_job
    queue = Sidekiq::ScheduledSet.new
    queue.each do |job|
      next unless job.jid.eql?(@schedule_message.job_id)

      job.delete
      break
    end
  end

  def reschedule_job
    time = @schedule_message.scheduled_at.in_time_zone(Current.profile.time_zone)
    job = ScheduleMessageJob.set(wait_until: time).perform_later(Current.profile.id, @schedule_message.id)
    @schedule_message.update!(job_id: job.provider_job_id)
  end
end