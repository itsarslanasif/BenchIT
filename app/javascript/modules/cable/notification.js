import { useUnreadStore } from '../../stores/useUnreadStore';
import { useDirectMessagesStore } from '../../stores/useDirectMessagesStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import { useMessageStore } from '../../stores/useMessagesStore';

const createMessage = data => {
  const profile_list = useProfileStore();
  const receiver = profile_list.getProfileById(data.sender_id);
  const direct_message_list = useDirectMessagesStore();
  direct_message_list.appendToDirectMessagesList(receiver);

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

const updateProfileStatus = data => {
  const { setProfileStatus, setProfileActiveStatus, currentProfile } = useCurrentProfileStore();
  const { updateProfileStatus } = useProfileStore();
  const { updateProfileStatus:updateDmProfileStatus } = useDirectMessagesStore();
  const { updateSelectedprofileStatus } = useMessageStore();

  if (currentProfile.id === data.id) {
    setProfileStatus(data.status);
    setProfileActiveStatus(data.is_active)
  }
    updateProfileStatus(data);
    updateDmProfileStatus(data);
    updateSelectedprofileStatus(data)
  };

const notificationActions = {
  MessageCreate: createMessage,
  MessageDelete: deleteMessage,
  ChannelParticipantCreate: ChannelParticipantCreate,
  ChannelParticipantDelete: ChannelParticipantDelete,
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
