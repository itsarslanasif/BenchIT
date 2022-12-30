class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "NotificationChannel#{params[:workspace_id]}-#{params[:profile_id]}"
  end
end
