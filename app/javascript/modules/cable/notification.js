import {
  useUnreadStore
} from '../../stores/useUnreadStore';

import {
  useDirectMessagesStore
} from '../../stores/useDirectMessagesStore';

import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
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

const updateProfileStatus = data => {
  const currentProfileStore = useCurrentProfileStore();
  let profile=currentProfileStore.currentProfile;
  if(profile.id==data.id){
    currentProfileStore.setProfileStatus(data.status)
  }
  const dmStore = useDirectMessagesStore();
  dmStore.updateProfileStatus(data)

}

const notificationActions = {
  MessageCreate: createMessage,
  MessageDelete: deleteMessage,
  ProfileUpdate: updateProfileStatus,
};

export const notifyActions = data => {
  try {
    const key = data.type + data.action;
    notificationActions[key](data.content);
  } catch (err) {
    console.error(err);
  }
};
