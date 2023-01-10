import { useUnreadStore } from "../../stores/useUnreadStore";

const createMessage = (data) => {
  const unreadMessagesStore = useUnreadStore()
  try {
    if (!data.parent_message_id) {
      unreadMessagesStore.addNewMessage(data)
    }
  } catch (err) {
    console.error(err);
  }
};

const deleteMessage = (data) => {
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
  try {
    console.log(data)
    const key = data.type + data.action;
    notificationActions[key](data.content);
  } catch (err) {
    console.error(err);
  }
};
