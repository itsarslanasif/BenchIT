import { useUnreadStore } from '../../stores/useUnreadStore';
import { useChannelStore } from '../../stores/useChannelStore';

const createMessage = data => {
  const unreadMessagesStore = useUnreadStore();
  const getIndexByParams = param => {
    return window.location.pathname.split('/')[param];
  };
  const conversation_type = getIndexByParams(1);
  const id = getIndexByParams(2);
  try {
    if (!data.parent_message_id) {
      unreadMessagesStore.addNewMessage(data, conversation_type, id);
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

const ChannelParticipantCreate = async data => {
  const channelsStore = useChannelStore();
  channelsStore.addChannelJoined(data);
};

const ChannelParticipantDelete = async data => {
  const channelsStore = useChannelStore();
  channelsStore.removeChannelJoined(data);
};

const notificationActions = {
  MessageCreate: createMessage,
  MessageDelete: deleteMessage,
  ChannelParticipantCreate: ChannelParticipantCreate,
  ChannelParticipantDelete: ChannelParticipantDelete,
};

export const notifyActions = data => {
  try {
    const key = data.type + data.action;
    notificationActions[key](data.content);
  } catch (err) {
    console.error(err);
  }
};
