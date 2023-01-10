
const createMessage = (data, messageStore) => {
  try {
    const messages = messageStore.getMessages;
    if (data.parent_message_id) {
      const message = messages.find(m => m.id === data.parent_message_id);
      message.replies.push(data);
    } else {
      const findMessage = messages.find(m => m.id === data.id);
      if (findMessage == undefined) {
        messageStore.addMessage(data);
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const deleteMessage = (data, messageStore) => {
  try {
    const messages = messageStore.getMessages;
    if (data.parent_message_id) {
      const message = messages.find(m => m.id === data.parent_message_id);
      const findThreadMessageIndex = message.replies.findIndex(
        m => m.id === data.id
      );
      if (findThreadMessageIndex != -1) {
        message.replies.splice(findThreadMessageIndex, 1);
      }
    } else {
      const findMessageIndex = messages.findIndex(m => m.id === data.id);
      if (findMessageIndex != -1) {
        messages.splice(findMessageIndex, 1);
      }
    }
  } catch (err) {
    console.error(err);
  }
};


const notificationActions = {
  MessageCreate: createMessage,
  MessageDelete: deleteMessage,
};

export const notifyActions = data => {
  // const messageStore = useMessageStore();
  try {
    const key = data.type + data.action;
    notificationActions[key](data.content, messageStore);
  } catch (err) {
    console.error(err);
  }
};
