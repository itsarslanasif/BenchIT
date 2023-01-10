import { useUnreadStore } from '../../stores/useUnreadStore';

const createMessage = data => {
  const unreadMessagesStore = useUnreadStore();
  try {
    if (!data.parent_message_id) {
      unreadMessagesStore.addNewMessage(data);
    }
  } catch (err) {
    console.error(err);
  }
};

const deleteMessage = data => {
  const unreadMessagesStore = useUnreadStore();
  try {
    if (!data.parent_message_id) {
      unreadMessagesStore.removeMessage(data);
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
    const key = data.type + data.action;
    notificationActions[key](data.content);
  } catch (err) {
    console.error(err);
  }
};
