export const unreadMessagesCount = (unreadMessages, channel, conversation_type) => {
  let unreadMessagesLength = 0
  if (unreadMessages.length && channel?.id) {
    unreadMessages.forEach(element => {
      if (element.bench_conversation == `${conversation_type}${channel.id}`) {
        unreadMessagesLength = element.messages.length;
      }
    });
  }
  return unreadMessagesLength
}