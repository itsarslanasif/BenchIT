export const unreadMessagesCount = (unreadMessages, conversation_type) => {
  if (unreadMessages.length) {
    return unreadMessages.find(m => m.bench_conversation === conversation_type);
  }
};