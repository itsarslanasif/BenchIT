class ChatChannel < ApplicationCable::Channel

  def subscribed
    stream_from "ChatChannel#{params[:id]}"
  end

  def receive(data)
    ActionCable.server.broadcast("ChatChannel", {
      message: data['message'].upcase
    })
  end
end
