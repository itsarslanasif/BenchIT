class ChatChannel < ApplicationCable::Channel

  def subscribed
    if params[:type] == "users"
      current_user = User.first
      conversation = BenchConversation.where(conversationable_type: "User", sender_id: current_user.id, conversationable_id: params[:id].to_i).or(BenchConversation.where(conversationable_type: "User", sender_id: params[:id].to_i, conversationable_id: current_user.id)).last
      stream_from "ChatChannel#{conversation.conversationable_id}"
    else
      stream_from "ChatChannel#{params[:id]}"
    end
  end

  def receive(data)
    ActionCable.server.broadcast("ChatChannel", {
      message: data['message'].upcase
    })
  end
end
