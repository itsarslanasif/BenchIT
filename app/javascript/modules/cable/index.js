import { useMessageStore } from '../../stores/useMessagesStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { useThreadStore } from '../../stores/useThreadStore';
import { usePinnedConversation } from '../../stores/UsePinnedConversationStore';

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

const updateMessage = (data, messageStore, threadStore) => {
  try {
    if (data.parent_message_id) {
      const message = messageStore.messages.find(
        element => element.id === data.parent_message_id
      );
      const findThreadMessageIndex = message.replies.findIndex(
        element => element.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        message.replies[findThreadMessageIndex] = data;
      }
    } else {
      const findMessageIndex = messageStore.messages.findIndex(
        element => element.id === data.id
      );

      if (findMessageIndex != -1) {
        let messsageToUpdate = { ...data };
        messsageToUpdate.replies =
          messageStore.messages[findMessageIndex].replies;
        messageStore.messages[findMessageIndex] = messsageToUpdate;
        if (threadStore?.message && threadStore.message.id == data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
  } catch (error) {
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

const pinMessage = (data, messageStore, threadStore, pinStore) => {
  try {
    const pinnedMessages = pinStore.getPinnedConversation;
    const pin = pinnedMessages.find(m => m.pin.id === data.pin.id);

    if (data.parent_message_id) {
      const message = messageStore.messages.find(
        element => element.id === data.parent_message_id
      );
      const findThreadMessageIndex = message.replies.findIndex(
        element => element.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        message.replies[findThreadMessageIndex] = data;
        if (pin == undefined) {
          pinStore.pinMessage(message.replies[findThreadMessageIndex]);
        }
      }
    } else {
      const findMessageIndex = messageStore.messages.findIndex(
        element => element.id === data.id
      );

      if (findMessageIndex != -1) {
        let messsageToUpdate = { ...data };
        messsageToUpdate.replies =
          messageStore.messages[findMessageIndex].replies;
        messageStore.messages[findMessageIndex] = messsageToUpdate;
        if (pin == undefined) {
          pinStore.pinMessage(messsageToUpdate);
        }
        if (threadStore?.message && threadStore.message.id == data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
  } catch (error) {
    console.error(err);
  }
};

const unPinMessage = (data, messageStore, threadStore, pinStore) => {
  try {
    const pinnedMessages = pinStore.getPinnedConversation;
    const pin = pinnedMessages.find(m => m.id === data.id);

    if (data.parent_message_id) {
      const message = messageStore.messages.find(
        element => element.id === data.parent_message_id
      );
      const findThreadMessageIndex = message.replies.findIndex(
        element => element.id === data.id
      );
      console.log(findThreadMessageIndex);

      if (findThreadMessageIndex != -1) {
        message.replies[findThreadMessageIndex] = data;
        if (pin != undefined) {
          pinStore.unPinMessage(message.replies[findThreadMessageIndex]);
        }
      }
    } else {
      const findMessageIndex = messageStore.messages.findIndex(
        element => element.id === data.id
      );

      if (findMessageIndex != -1) {
        let messsageToUpdate = { ...data };
        messsageToUpdate.replies =
          messageStore.messages[findMessageIndex].replies;
        messageStore.messages[findMessageIndex] = messsageToUpdate;
        if (pin != undefined) {
          pinStore.unPinMessage(messsageToUpdate);
        }
        if (threadStore?.message && threadStore.message.id == data.id) {
          threadStore.message = messsageToUpdate;
        }
      }
    }
  } catch (error) {
    console.error(error);
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
