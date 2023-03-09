class BroadcastMessageNotificationService
  def initialize(message_json, profile_ids)
    @message_json = message_json
    @profile_ids = profile_ids
  end

  def call
    send_notification_ws
  end

  private

  def send_notification_ws
    return if @profile_ids.empty?

    @profile_ids.each do |id|
      notification_key = "NotificationChannel#{Current.workspace.id}-#{id}"
      if @message_json[:type].eql?('Group')
        notify_group(notification_key)
      elsif @message_json[:type].eql?('Profile') || (id != Current.profile.id)
        ActionCable.server.broadcast(notification_key,
                                     { message: @message_json })
      end
    end
  end

  def notify_group(notification_key)
    ActionCable.server.broadcast(notification_key, { message: @message_json })
  end
end
