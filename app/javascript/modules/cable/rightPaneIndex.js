import { useRightpaneMessageStore } from '../../stores/useRightpaneMessageStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { useRightPaneThreadStore } from '../../stores/useRightPaneThreadStore';
import { useRightPanePinnedConversation } from '../../stores/useRightPanePinnedConversationStore';
import { useRightPaneStore } from '../../stores/useRightPaneStore';

const findMessageIndex = (messages, dataID) =>
  messages.findIndex(message => message.id === dataID);

const findMessage = (messages, dataID) => messages.find(message => message.id === dataID);

const createMessage = (data, messageStore, threadStore) => {
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const parentMessage = findMessage(messages, data.parent_message_id);
      const threadMessage = threadStore.getMessage;
      const message = findMessage(parentMessage.replies, data.id)
      !message ? parentMessage.replies.push(data) : null;
      const findThreadMessage = findMessage(threadMessage.replies, data.id)

      if (!findThreadMessage && threadMessage.id === data.parent_message_id) {
        threadMessage.replies.push(data);
      }
    } else {
      const message = findMessage(messages, data.id)
      !message ? messageStore.addMessage(data) : null;
    }
  } catch (err) {
    console.error(err);
  }
};

const deleteMessage = (data, messageStore, threadStore, rightPaneStore) => {
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const parentMessage = findMessage(messages, data.parent_message_id)
      let findThreadMessageIndex = findMessageIndex(parentMessage.replies, data.id)

      if (findThreadMessageIndex != -1) {
        parentMessage.replies.splice(findThreadMessageIndex, 1);
      }

      const threadMessage = threadStore.getMessage;
      findThreadMessageIndex = findMessageIndex(threadMessage.replies, data.id)

      if (findThreadMessageIndex != -1) {
        threadMessage.replies.splice(findThreadMessageIndex, 1);
      }
    } else {
      const messageIndex = findMessageIndex(messages, data.id)

      if (messageIndex != -1) {
        messages.splice(messageIndex, 1);
        const threadMessage = threadStore.getMessage;

        if (threadMessage.id === data.id) {
          threadMessage.replies.splice(0, threadMessage.replies.length);
          threadStore.setMessage(null);
          rightPaneStore.toggleRightPaneThreadShow(false);
        }
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const updateMessage = (data, messageStore, threadStore) => {
  try {
    let messageIndex = -1;
    if (data.parent_message_id) {
      const parentMessage = findMessage(messageStore.messages, data.parent_message_id);
      messageIndex = findMessageIndex(parentMessage.replies, data.id);
      parentMessage.replies[messageIndex] = messageIndex != -1 ? data : null
    } else {
      messageIndex = findMessageIndex(messageStore.messages, data.id);

      if (messageIndex != -1) {
        let messsageToUpdate = {
          ...data,
        };
        messsageToUpdate.replies = messageStore.messages[messageIndex].replies;
        messageStore.messages[messageIndex] = messsageToUpdate;

        if (threadStore?.message && threadStore.message.id === data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
    if (messageIndex === -1 && data.attachments) {
      createMessage(data, messageStore, threadStore);
    }
  } catch (err) {
    console.error(err);
  }
};

const createReaction = (data, messageStore) => {
  try {
    let messages = messageStore.getMessages
      .flatMap(message => [message, message.replies])
      .flat();
    const message = findMessage(messages, data.conversation_message_id)

    if (message) {
      const findMessageReactionIndex = message.reactions.findIndex(
        reaction => reaction.id === data.id
      );
      findMessageReactionIndex == -1 ? message.reactions.push(data) : null
    }
  } catch (err) {
    console.error(err);
  }
};

const deleteReaction = (data, messageStore) => {
  try {
    let messages = messageStore.getMessages
      .flatMap(message => [message, message.replies])
      .flat();
    const message = findMessage(messages, data.conversation_message_id)
    const findMessageReactionIndex = message.reactions.findIndex(
      reaction => reaction.id === data.id
    );

    if (message != -1 && findMessageReactionIndex != -1) {
      message.reactions.splice(findMessageReactionIndex, 1);
    }
  } catch (err) {
    console.error(err);
  }
};

const pinMessage = (data, messageStore, threadStore, pinStore) => {
  try {
    const pinnedMessages = pinStore.getPinnedConversation;
    const pin = pinnedMessages.find(msg => msg.pin.id === data.pin.id);

    if (data.parent_message_id) {
      const parentMessage = findMessage(messageStore.messages, data.parent_message_id);
      const replyIndex = findMessageIndex(parentMessage.replies, data.id);
      parentMessage.replies[replyIndex] = replyIndex != -1 ? data : null
      !pin ? pinStore.pinMessage(parentMessage.replies[replyIndex]) : null
    } else {
      const messageIndex = findMessageIndex(messageStore.messages, data.id);

      if (messageIndex != -1) {
        let messsageToUpdate = {
          ...data,
        };
        messsageToUpdate.replies = messageStore.messages[messageIndex].replies;
        messageStore.messages[messageIndex] = messsageToUpdate;
        !pin ? pinStore.pinMessage(messsageToUpdate) : null

        if (threadStore?.message && threadStore.message.id == data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const unPinMessage = (data, messageStore, threadStore, pinStore) => {
  try {
    const pinnedMessages = pinStore.getPinnedConversation;
    const pin = findMessage(pinnedMessages, data.id)

    if (data.parent_message_id) {
      const parentMessage = findMessage(messageStore.messages, data.parent_message_id);
      const replyIndex = findMessageIndex(parentMessage.replies, data.id);
      parentMessage.replies[replyIndex] = replyIndex != -1 ? data : null
      pin ? pinStore.unPinMessage(parentMessage.replies[replyIndex]) : null
    }
    else {
      const messageIndex = findMessageIndex(messageStore.messages, data.id);

      if (messageIndex != -1) {
        let messsageToUpdate = {
          ...data,
        };
        messsageToUpdate.replies = messageStore.messages[messageIndex].replies;
        messageStore.messages[messageIndex] = messsageToUpdate;
        pin ? pinStore.unPinMessage(messsageToUpdate) : null

        if (threadStore?.message && threadStore.message.id == data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const ChannelParticipantCreate = data => {
  const channelDetailsStore = useChannelDetailStore();
  channelDetailsStore.addMember(data);
};

const ChannelParticipantDelete = data => {
  const channelDetailsStore = useChannelDetailStore();
  channelDetailsStore.removeMember(data);
};

const actions = {
  MessageCreate: createMessage,
  ReactionCreate: createReaction,
  MessageDelete: deleteMessage,
  ReactionDelete: deleteReaction,
  MessageUpdate: updateMessage,
  PinCreate: pinMessage,
  PinDelete: unPinMessage,
  ChannelParticipantCreate: ChannelParticipantCreate,
  ChannelParticipantDelete: ChannelParticipantDelete,
};

export const cableActions = data => {
  const messageStore = useRightpaneMessageStore();
  const threadStore = useRightPaneThreadStore();
  const rightPaneStore = useRightPaneStore();
  const pinStore = useRightPanePinnedConversation();

  try {
    const key = data.type + data.action;
    actions[key](
      data.content,
      messageStore,
      threadStore,
      pinStore,
      rightPaneStore
    );
  } catch (err) {
    console.error(err);
  }
};
