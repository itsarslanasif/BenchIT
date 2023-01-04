import { useMessageStore } from '../../stores/useMessagesStore';

const createMessage = (data, messageStore) => {
  try {
    const messages = messageStore.getMessages;
    if (data.parent_message_id) {
      const message = messages.find(m => m.id === data.parent_message_id);
      message.replies.push(data);
    } else {
      const findMessage = messages.find(m => m.id === data.id);
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
      const message = messages.find(m => m.id === data.parent_message_id);
      message.replies.push(data);
    } else {
      const findMessage = messages.find(m => m.id === data.id);
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
      const message = messages.find(m => m.id === data.parent_message_id);
      const findThreadMessageIndex = message.replies.findIndex(
        m => m.id === data.id
      );
      if (findThreadMessageIndex != -1) {
        message.replies.splice(findThreadMessageIndex, 1);
      }
    } else {
      const findMessageIndex = messages.findIndex(m => m.id === data.id);
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
    const message = messages.find(m => m.id === data.conversation_message_id);
    if (message) {
      message.reactions.push(data);
    }
  } catch (err) {
    console.error(err);
  }
};

const actions = {
  MessageCreate: createMessage,
  ReactionCreate: createReaction,
  MessageDelete: deleteMessage,
  MessageUpdate: updateMessage,
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