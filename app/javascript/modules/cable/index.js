import { useMessageStore } from '../../stores/useMessagesStore';

const MessageHandler = (data, action, messageStore) => {
  switch (action) {
    case 'Create':
      const findMessage = messageStore.getMessages.find(m => m.id === data.id);
      if (findMessage == undefined) {
        messageStore.addMessage(data);
      }
      break;
    case 'Update':
      break;
    case 'Delete':
      break;
    default:
      break;
  }
}

const BookmarkHandler = (data, action) => {
  switch (action) {
    case 'Create':
      break;
    case 'Update':
      break;
    case 'Delete':
      break;
    default:
      break;
  }
}

const PinHandler = (data, action) => {
  switch (action) {
    case 'Create':
      break;
    case 'Update':
      break;
    case 'Delete':
      break;
    default:
      break;
  }
}

const ReactionHandler = (data, action, messageStore) => {
  switch (action) {
    case 'Create':
      const messages = messageStore.getMessages
      const message = messages.find(m => m.id === data.conversation_message_id);
      message.reactions.push(data)
      break;
    case 'Update':
      break;
    case 'Delete':
      break;
    default:
      break;
  }
}

export const cableActions = (data) => {
  const messageStore = useMessageStore();
  switch (data.type) {
    case 'Message':
      MessageHandler(data.content, data.action, messageStore)
      break;
    case 'Bookmark':
      BookmarkHandler(data.content, data.action)
      break;
    case 'Pin':
      Pin(data.content, data.action)
      break;
    case 'Reaction':
      ReactionHandler(data.content, data.action, messageStore)
      break;
    default:
      break;
  }
}