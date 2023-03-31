import { useMessageStore } from '../../stores/useMessagesStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { useThreadStore } from '../../stores/useThreadStore';
import { usePinnedConversation } from '../../stores/UsePinnedConversationStore';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import { useChannelStore } from '../../stores/useChannelStore';

const createMessage = (data, messageStore, threadStore) => {
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const message = messages.find(
        element => element.id === data.parent_message_id
      );
      const threadMessage = threadStore.getMessage;
      const findMessage = message.replies.find(
        element => element.id === data.id
      );

      if (findMessage === undefined) {
        message.replies.push(data);
      }

      const findThreadMessage = threadMessage.replies.find(
        element => element.id === data.id
      );

      if (
        findThreadMessage === undefined &&
        threadMessage.id === data.parent_message_id
      ) {
        threadMessage.replies.push(data);
      }
    } else {
      const findMessage = messages.find(element => element.id === data.id);

      if (findMessage == undefined) {
        messageStore.addMessage(data);
      }
    }
  } catch (e) {
    errorHandler(e.response.data.message);
  }
};

const findMessageIndex = (messages, data) =>
  messages.findIndex(message => message.id === data.id);

const findParentMessage = (messages, data) =>
  messages.find(message => message.id === data.parent_message_id);

const deleteMessage = (
  data,
  messageStore,
  threadStore,
  pinStore,
  rightPaneStore
) => {
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

      const threadMessage = threadStore.getMessage;
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
        const threadMessage = threadStore.getMessage;

        if (threadMessage.id === data.id) {
          threadMessage.replies.splice(0, threadMessage.replies.length);
          threadStore.setMessage(null);
          rightPaneStore.toggleThreadShow(false);
        }
      }
    }
  } catch (e) {
    errorHandler(e.response.data.message);
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
  } catch (e) {
    errorHandler(e.response.data.message);
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
  } catch (e) {
    errorHandler(e.response.data.message);
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
  } catch (e) {
    errorHandler(e.response.data.message);
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
  } catch (e) {
    errorHandler(e.response.data.message);
  }
};

const unPinMessage = (data, messageStore, threadStore, pinStore) => {
  try {
    const pinnedMessages = pinStore.getPinnedConversation;
    const pin = pinnedMessages.find(messge => messge.id === data.id);

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
  } catch (e) {
    errorHandler(e.response.data.message);
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

const updateBenchConversation = (data, messageStore) => {
  messageStore.selectedChat.topic = data.topic;
};

const updateBenchChannel = (data, messageStore, channelStore) => {
  messageStore.selectedChat.description = data.description;
  const index = channelStore.channels.findIndex(
    element => element.id === data.id
  );
  channelStore.channels[index] = data

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
  BenchConversationUpdate: updateBenchConversation,
  BenchChannelUpdate: updateBenchChannel,
};

export const cableActions = data => {
  const messageStore = useMessageStore();
  const threadStore = useThreadStore();
  const rightPaneStore = useRightPaneStore();
  const pinStore = usePinnedConversation();
  const channelStore = useChannelStore();

  try {
    const key = data.type + data.action;
    actions[key](
      data.content,
      messageStore,
      threadStore,
      pinStore,
      rightPaneStore,
      channelStore
    );
  } catch (e) {
    errorHandler(e.response.data.message);
  }
};
