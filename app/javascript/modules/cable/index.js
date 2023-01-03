import { useMessageStore } from '../../stores/useMessagesStore';

const createMessage = (data, messageStore) => {
  try {
    const messages = messageStore.getMessages;
    if (data.parent_message_id) {
      const message = messages.find(m => m.id === data.parent_message_id);
      message.replies.push(data);
    } else {
      const findMessage = messageStore.getMessages.find(m => m.id === data.id);
      if (findMessage == undefined) {
        messageStore.addMessage(data);
      }
    }
  } catch (err) {
    console.error(err);
  }
};

const createReaction = (data, messageStore) => {
  try {
    let messages = messageStore.getMessages;
    messages = messages.flatMap(message => [message, message.replies]).flat();
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
