module ConverstaionMessagesHelper
  def messages_from_ids(message_ids)
    ConversationMessage.messages_by_ids_array(message_ids)
  end
end
