class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from case params[:type]
                when 'profiles'
                  conversation = BenchConversation.profile_to_profile_conversation(params[:id], params[:current_profile_id])

                  if conversation.blank?
                    conversation = BenchConversation.new(conversationable_type: 'Profile', conversationable_id: params[:id],
                                                         sender_id: params[:current_profile_id])
                    conversation.save
                  end

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
