class ChatChannel < ApplicationCable::Channel

  def subscribed
    if params[:type] == "users"
      current_user = User.first
      conversation = BenchConversation.user_to_user_conversation(current_user.id,params[:id]).last
      if conversation.nil?
        conversation = BenchConversation.user_to_user_conversation(params[:id],current_user.id).last
      end
      stream_from "ChatChannelUser#{conversation.conversationable_id}#{conversation.sender_id}"
    elsif params[:type] == "groups"
      stream_from "ChatChannelGroup#{params[:id]}"
    else
      stream_from "ChatChannelBenchChannel#{params[:id]}"
    end
  end

  def receive(data)
    ActionCable.server.broadcast("ChatChannel", {
      message: data['message'].upcase
    })
  end
end
