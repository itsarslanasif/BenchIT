class BroadcastMessageService
  def initialize(message_json, bench_conversation)
    @message_json = message_json
    @bench_conversation = bench_conversation
  end

  def call
    broadcast_message
    send_notification_ws
  end

  private

  def broadcast_message
    channel_key = "ChatChannel#{@bench_conversation.conversationable_type}#{@bench_conversation.conversationable_id}"
    channel_key += "-#{@bench_conversation.sender_id}" if @bench_conversation.conversationable_type.eql?('Profile')

    ActionCable.server.broadcast(channel_key, { message: @message_json })
  end

  def send_notification_ws
    case @bench_conversation.conversationable_type
    when 'Profile'
      profile_ids = [@bench_conversation.conversationable_id, @message_json[:sender_id]]
    when 'Group'
      profile_ids = Group.find(@bench_conversation.conversationable_id).profile_ids
    when 'BenchChannel'
      profile_ids = BenchChannel.find(@bench_conversation.conversationable_id).profiles.pluck(:id)
    end
    return if profile_ids.empty?

    profile_ids.each do |id|
      if @message_json[:type].eql?('Message') && @message_json[:action].eql?('Create')
        UnreadMessagesService.new(@bench_conversation, id,
                                  @message_json[:content][:id]).call
      end
      notification_key = "NotificationChannel#{Current.workspace.id}-#{id}"
      ActionCable.server.broadcast(notification_key, { message: @message_json })
    end
  end
end
