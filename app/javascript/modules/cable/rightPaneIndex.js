import { useRightpaneMessageStore } from '../../stores/useRightpaneMessageStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { useRightPaneThreadStore } from '../../stores/useRightPaneThreadStore';
import { useRightPanePinnedConversation } from '../../stores/useRightPanePinnedConversationStore';
import { useRightPaneStore } from '../../stores/useRightPaneStore';

const findMessageIndex = (messages, data) =>
  messages.findIndex(message => message.id === data.id);

const findParentMessage = (messages, data) =>
  messages.find(message => message.id === data.parent_message_id);

const searchForMessage = (messages, data) => messages.find(message => message.id === data.id);

const createMessage = (data, messageStore, threadStore) => {
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const message = findParentMessage(messages, data);
      const threadMessage = threadStore.getMessage;
      const findMessage = searchForMessage(message.replies, data)

      if (!findMessage) {
        message.replies.push(data);
      }

      const findThreadMessage = searchForMessage(threadMessage.replies, data)

      if (!findThreadMessage && threadMessage.id === data.parent_message_id) {
        threadMessage.replies.push(data);
      }
    } else {
      const findMessage = searchForMessage(messages, data)

      if (!findMessage) {
        messageStore.addMessage(data);
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const deleteMessage = (data, messageStore, threadStore, rightPaneStore) => {
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const message = findParentMessage(messages, data)
      let findThreadMessageIndex = findMessageIndex(message.replies, data)

      if (findThreadMessageIndex != -1) {
        message.replies.splice(findThreadMessageIndex, 1);
      }

      const threadMessage = threadStore.getMessage;
      findThreadMessageIndex = findMessageIndex(threadMessage.replies, data)

      if (findThreadMessageIndex != -1) {
        threadMessage.replies.splice(findThreadMessageIndex, 1);
      }
    } else {
      const messageIndex = findMessageIndex(messages, data)

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
    let MessageIndex = -1;
    if (data.parent_message_id) {
      const message = findParentMessage(messageStore.messages, data);
      MessageIndex = findMessageIndex(message.replies, data);

      if (MessageIndex != -1) {
        message.replies[MessageIndex] = data;
      }
    } else {
      MessageIndex = findMessageIndex(messageStore.messages, data);

      if (MessageIndex != -1) {
        let messsageToUpdate = {
          ...data,
        };
        messsageToUpdate.replies = messageStore.messages[MessageIndex].replies;
        messageStore.messages[MessageIndex] = messsageToUpdate;

        if (threadStore?.message && threadStore.message.id === data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
    if (MessageIndex === -1 && data.attachments) {
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
    const message = messages.find(
      element => element.id === data.conversation_message_id
    );

    if (message) {
      const findMessageReactionIndex = message.reactions.findIndex(
        reaction => reaction.id === data.id
      );

      if (findMessageReactionIndex == -1) {
        message.reactions.push(data);
      }
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
    const message = messages.find(
      element => element.id === data.conversation_message_id
    );
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
      const message = findParentMessage(messageStore.messages, data);
      const replyIndex = findMessageIndex(message.replies, data);

      if (replyIndex != -1) {
        message.replies[replyIndex] = data;

        if (!pin) {
          pinStore.pinMessage(message.replies[replyIndex]);
        }
      }
    } else {
      const MessageIndex = findMessageIndex(messageStore.messages, data);

      if (MessageIndex != -1) {
        let messsageToUpdate = {
          ...data,
        };
        messsageToUpdate.replies = messageStore.messages[MessageIndex].replies;
        messageStore.messages[MessageIndex] = messsageToUpdate;

        if (!pin) {
          pinStore.pinMessage(messsageToUpdate);
        }

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
    const pin = searchForMessage(pinnedMessages, data)

    if (data.parent_message_id) {
      const message = findParentMessage(messageStore.messages, data);
      const replyIndex = findMessageIndex(message.replies, data);

      if (replyIndex != -1) {
        message.replies[replyIndex] = data;

        if (pin) {
          pinStore.unPinMessage(message.replies[replyIndex]);
        }
      }
    } else {
      const MessageIndex = findMessageIndex(messageStore.messages, data);

      if (MessageIndex != -1) {
        let messsageToUpdate = {
          ...data,
        };
        messsageToUpdate.replies = messageStore.messages[MessageIndex].replies;
        messageStore.messages[MessageIndex] = messsageToUpdate;

        if (pin) {
          pinStore.unPinMessage(messsageToUpdate);
        }

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
