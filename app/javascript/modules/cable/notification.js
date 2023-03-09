import { useUnreadStore } from '../../stores/useUnreadStore';
import { useDirectMessagesStore } from '../../stores/useDirectMessagesStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useGroupStore } from '../../stores/useGroupStore';

const getMessageBody = (details, data) => {
  let messageContent =
    data.conversationable_type === 'BenchChannel'
      ? `${data.sender_name}: `
      : '';
  const blocks = JSON.parse(data.content).blocks;
  for (let key in blocks) {
    messageContent += `${blocks[key].text.text} `;
  }
  return messageContent;
};

const showNotification = (details, data) => {
  const messageBody = getMessageBody(details, data);
  Notification.requestPermission().then(permission => {
    if (permission === 'granted') {
      new Notification(
        `New message from ${
          details.creator_id ? details.name : details.username
        }`,
        {
          body: messageBody,
        }
      );
    }
  });
};

const createPayloadForNotification = async data => {
  let messageDetail;
  if (data.conversationable_type === 'BenchChannel') {
    const channels = useChannelStore().getChannels;
    messageDetail = channels
      .filter(channel => channel.id === data.conversationable_id)
      .pop();
  } else if (data.conversationable_type === 'Profile') {
    const profileStore = useProfileStore();
    messageDetail = profileStore.getProfileById(data.conversationable_id);
  }
  showNotification(messageDetail, data);
};

const createMessage = data => {
  const profiles = useProfileStore();
  const receiver = profiles.getProfileById(data.sender_id);
  const direct_messages = useDirectMessagesStore();
  direct_messages.appendToDirectMessagesList(receiver);
  const unreadMessagesStore = useUnreadStore();
  const getIndexByParams = param => {
    return window.location.pathname.split('/')[param];
  };
  const conversation_type = getIndexByParams(1);
  const id = getIndexByParams(2);
  createPayloadForNotification(data);
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

  const createGroup = data =>{
    const groupStore=useGroupStore()
    groupStore.groups.push(data)
  };

const notificationActions = {
  MessageCreate: createMessage,
  MessageDelete: deleteMessage,
  ChannelParticipantCreate: ChannelParticipantCreate,
  ChannelParticipantDelete: ChannelParticipantDelete,
  ProfileUpdate: updateProfileStatus,
  GroupCreate : createGroup
};

export const notifyActions = data => {
  try {
    const key = data.type + data.action;
    notificationActions[key](data.content);
  } catch (err) {
    console.error(err);
  }
};
