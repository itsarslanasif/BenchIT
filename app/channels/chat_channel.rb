class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from case params[:type]
                when 'users'
                  conversation = BenchConversation.user_to_user_conversation(params[:id], params[:current_user_id])
                  "ChatChannelProfile#{conversation.conversationable_id}-#{conversation.sender_id}"
                when 'groups'
                  "ChatChannelGroup#{params[:id]}"
                when 'channels'
                  "ChatChannelBenchChannel#{params[:id]}"
                else
                  'ChatChannel'
                end
  end

  def receive(data)
    ActionCable.server.broadcast('ChatChannel', {
                                   message: data['message'].upcase
                                 })
  end
end
