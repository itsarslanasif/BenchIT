import { useMessageStore } from '../../stores/useMessagesStore';
import { usePinnedConversation } from '../../stores/UsePinnedConversationStore';

const createMessage = (data, messageStore) => {
  try {
    const messages = messageStore.getMessages;
    if (data.parent_message_id) {
      const message = messages.find(element => element.id === data.parent_message_id);
      message.replies.push(data);
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

const updateMessage = (data, messageStore) => {
  try {
    const messages = messageStore.getMessages;
    if (data.parent_message_id) {
      const message = messages.find(element => element.id === data.parent_message_id);
      message.replies.push(data);
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

const deleteMessage = (data, messageStore) => {
  try {
    const messages = messageStore.getMessages;
    if (data.parent_message_id) {
      const message = messages.find(element => element.id === data.parent_message_id);
      const findThreadMessageIndex = message.replies.findIndex(
        element => element.id === data.id
      );
      if (findThreadMessageIndex != -1) {
        message.replies.splice(findThreadMessageIndex, 1);
      }
    } else {
      const findMessageIndex = messages.findIndex(element => element.id === data.id);
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
    const message = messages.find(element => element.id === data.conversation_message_id);
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
    const message = messages.find(element => element.id === data.conversation_message_id);
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

const createPin = (data, messageStore) => {
  const pinsStore = usePinnedConversation();
  try {
    const messages = messageStore.getMessages;
    if (data.message.parent_message_id) {
      const message = messages.find(
        m => m.id === data.message.parent_message_id
      );
      const findThreadMessageIndex = message.replies.findIndex(
        m => m.id === data.message.id
      );
      if (findThreadMessageIndex != -1) {
        message.replies[findThreadMessageIndex] = data.message;
      }
    } else {
      const findMessageIndex = messages.findIndex(
        m => m.id === data.message.id
      );
      if (findMessageIndex != -1) {
        messages[findMessageIndex] = data.message;
      }
    }

    const pinnedMessages = pinsStore.getPinnedConversation;
    const pin = pinnedMessages.find(m => m.id === data.id);
    if (pin == undefined) {
      pinsStore.pinMessage(data);
    }
  } catch (err) {
    console.error(err);
  }
};

const actions = {
  MessageCreate: createMessage,
  ReactionCreate: createReaction,
  MessageDelete: deleteMessage,
  ReactionDelete: deleteReaction,
  MessageUpdate: updateMessage,
  PinCreate: createPin,
};

export const cableActions = data => {
  const messageStore = useMessageStore();
  try {
    const key = data.type + data.action;
    actions[key](data.content, messageStore);
  } catch (err) {
    console.error(err);
  }
};
