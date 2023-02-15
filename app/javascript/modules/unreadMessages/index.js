export const unreadMessagesCount = (unreadMessages, conversation_type) => {
  if (unreadMessages.length) {
    return unreadMessages.find(m => m.bench_conversation === conversation_type);
  }
};

export const unreadMessagesLength = (unreadMessage) => {
  if (unreadMessage.messages.length > unreadMessage.total_unread_messages) {
    return unreadMessage.messages.length;
  } else {
    return unreadMessage.total_unread_messages;
  }
};
