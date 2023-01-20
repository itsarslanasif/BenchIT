import { useMessageStore } from '../../stores/useMessagesStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { useThreadStore } from '../../stores/useThreadStore';
import { usePinnedConversation } from '../../stores/UsePinnedConversationStore';
import useUserStatusStore from '../../stores/useUserStatusStore';

const createMessage = (data, messageStore, threadStore) => {
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const message = messages.find(
        element => element.id === data.parent_message_id
      );
      const threadMessage = threadStore.getMessages;
      const findMessage = message.replies.find(
        element => element.id === data.id
      );
      if (findMessage === undefined) {
        message.replies.push(data);
      }
      const findThreadMessage = threadMessage.replies.find(
        element => element.id === data.id
      );
      if (findThreadMessage === undefined) {
        threadMessage.replies.push(data);
      }
    } else {
      const findMessage = messages.find(element => element.id === data.id);

      if (findMessage == undefined) {
        messageStore.addMessage(data);
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const findThreadMessageIndex = (message, data) =>
  message.replies.findIndex(element => element.id === data.id);

const findMessageIndex = (messages, data) =>
  messages.findIndex(element => element.id === data.id);

const updateMessage = (data, messageStore, threadStore) => {
  try {
    if (data.parent_message_id) {
      const message = messageStore.messages.find(
        element => element.id === data.parent_message_id
      );
      const ThreadMessageIndex = findThreadMessageIndex(message, data);

      if (ThreadMessageIndex != -1) {
        message.replies[ThreadMessageIndex] = data;
      }
    } else {
      const MessageIndex = findMessageIndex(messageStore.messages, data);

      if (MessageIndex != -1) {
        let messsageToUpdate = { ...data };
        messsageToUpdate.replies = messageStore.messages[MessageIndex].replies;
        messageStore.messages[MessageIndex] = messsageToUpdate;

        if (threadStore?.message && threadStore.message.id === data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const deleteMessage = (data, messageStore, threadStore) => {
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const message = messages.find(
        element => element.id === data.parent_message_id
      );
      let findThreadMessageIndex = message.replies.findIndex(
        element => element.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        message.replies.splice(findThreadMessageIndex, 1);
      }

      const threadMessage = threadStore.getMessages;
      findThreadMessageIndex = threadMessage.replies.findIndex(
        element => element.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        threadMessage.replies.splice(findThreadMessageIndex, 1);
      }
    } else {
      const findMessageIndex = messages.findIndex(
        element => element.id === data.id
      );

      if (findMessageIndex != -1) {
        messages.splice(findMessageIndex, 1);
      }
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

const check = () => {
  console.log('asdadsad');
};

const pinMessage = (data, messageStore, threadStore, pinStore) => {
  try {
    check;
    const pinnedMessages = pinStore.getPinnedConversation;
    const pin = pinnedMessages.find(msg => msg.pin.id === data.pin.id);

    if (data.parent_message_id) {
      const message = messageStore.messages.find(
        element => element.id === data.parent_message_id
      );
      const ThreadMessageIndex = findThreadMessageIndex(message, data);
      if (ThreadMessageIndex != -1) {
        message.replies[ThreadMessageIndex] = data;
        if (!pin) {
          pinStore.pinMessage(message.replies[ThreadMessageIndex]);
        }
      }
    } else {
      const MessageIndex = findMessageIndex(messageStore.messages, data);

      if (MessageIndex != -1) {
        let messsageToUpdate = { ...data };
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
    const pin = pinnedMessages.find(msg => msg.id === data.id);

    if (data.parent_message_id) {
      const message = messageStore.messages.find(
        element => element.id === data.parent_message_id
      );
      const ThreadMessageIndex = findThreadMessageIndex(message, data);

      if (ThreadMessageIndex != -1) {
        message.replies[ThreadMessageIndex] = data;
        if (pin) {
          pinStore.unPinMessage(message.replies[ThreadMessageIndex]);
        }
      }
    } else {
      const MessageIndex = findMessageIndex(messageStore.messages, data);

      if (MessageIndex != -1) {
        let messsageToUpdate = { ...data };
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
  const messageStore = useMessageStore();
  const threadStore = useThreadStore();
  const pinStore = usePinnedConversation();

  try {
    const key = data.type + data.action;
    actions[key](data.content, messageStore, threadStore, pinStore);
  } catch (err) {
    console.error(err);
  }
};
