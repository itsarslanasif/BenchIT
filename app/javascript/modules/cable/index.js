import { useMessageStore } from '../../stores/useMessagesStore';
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

const pinMessage = (data, messageStore, threadStore) => {
  const pinsStore = usePinnedConversation();
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const message = messages.find(m => m.id === data.parent_message_id);
      let findThreadMessageIndex = message.replies.findIndex(
        m => m.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        message.replies[findThreadMessageIndex] = data;
      }

      const threadMessage = threadStore.getMessages;
      findThreadMessageIndex = threadMessage.replies.findIndex(
        element => element.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        threadMessage.replies[findThreadMessageIndex] = data;
      }
    } else {
      const findMessageIndex = messages.findIndex(m => m.id === data.id);

      if (findMessageIndex != -1) {
        messages[findMessageIndex] = data;
      }
    }

    const pinnedMessages = pinsStore.getPinnedConversation;
    const pin = pinnedMessages.find(m => m.pin.id === data.pin.id);

    if (pin == undefined) {
      pinsStore.pinMessage(data);
    }
  } catch (err) {
    console.error(err);
  }
};

const unPinMessage = (data, messageStore, threadStore) => {
  const pinsStore = usePinnedConversation();
  try {
    const messages = messageStore.getMessages;

    if (data.parent_message_id) {
      const message = messages.find(m => m.id === data.parent_message_id);
      const findThreadMessageIndex = message.replies.findIndex(
        m => m.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        message.replies[findThreadMessageIndex] = data;
      }

      const threadMessage = threadStore.getMessages;
      findThreadMessageIndex = threadMessage.replies.findIndex(
        element => element.id === data.id
      );

      if (findThreadMessageIndex != -1) {
        threadMessage.replies[findThreadMessageIndex] = data;
      }
    } else {
      const findMessageIndex = messages.findIndex(m => m.id === data.id);

      if (findMessageIndex != -1) {
        messages[findMessageIndex] = data;
      }
    }
    pinsStore.unPinMessage(data);
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
  PinCreate: pinMessage,
  PinDelete: unPinMessage,
};

export const cableActions = data => {
  const messageStore = useMessageStore();
  const threadStore = useThreadStore();
  try {
    const key = data.type + data.action;
    actions[key](data.content, messageStore, threadStore);
  } catch (err) {
    console.error(err);
  }
};
