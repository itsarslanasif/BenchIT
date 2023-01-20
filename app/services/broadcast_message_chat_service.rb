class BroadcastMessageChatService
  def initialize(message_json, bench_conversation)
    @message_json = message_json
    @bench_conversation = bench_conversation
  end

  def call
    broadcast_message
  end

  private

  def broadcast_message
    channel_key = "ChatChannel#{@bench_conversation.conversationable_type}#{@bench_conversation.conversationable_id}"
    channel_key += "-#{@bench_conversation.sender_id}" if @bench_conversation.conversationable_type.eql?('Profile')

    ActionCable.server.broadcast(channel_key, { message: @message_json })
  end
end
