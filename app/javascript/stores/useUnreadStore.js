import { defineStore } from 'pinia';
import { getUnreadMessages } from '../api/notification';

const getConversationType = type => {
  let conversation_type = '';
  switch (type) {
    case 'channels':
      conversation_type = 'BenchChannel';
      break;
    case 'groups':
      conversation_type = 'Group';
      break;
    case 'profiles':
      conversation_type = 'Profile';
      break;
  }
  return conversation_type;
};

const isMessageBelongsToChatOpened = (
  message,
  conversation_type,
  conversation_id
) => {
  const conversation_key = `${conversation_type}${conversation_id}`;
  const message_conversation_key = `${message.conversationable_type}${
    message.conversationable_type === 'Profile'
      ? message.sender_id
      : message.conversationable_id
  }`;
  return message_conversation_key === conversation_key;
};

const getMessageBelongsToUnreadChat = (message, unread_message_detail) => {
  if (
    unread_message_detail.bench_conversation ===
    `${message.conversationable_type}${
      message.conversationable_type === 'Profile'
        ? message.sender_id
        : message.conversationable_id
    }`
  ) {
    return unread_message_detail;
  }
};

export const useUnreadStore = () => {
  const unreadStore = defineStore('useUnreadStore', {
    state: () => {
      return {
        unreadMessages: [],
      };
    },

    getters: {
      getUnreadMessages: state => state.unreadMessages,
    },

    actions: {
      async index() {
        this.unreadMessages = await getUnreadMessages();
      },
      addNewMessage(message, conversation_type, conversation_id) {
        let unreadDetails = this.unreadMessages.find(unread_message_detail =>
          getMessageBelongsToUnreadChat(message, unread_message_detail)
        );
        if (
          !unreadDetails &&
          !isMessageBelongsToChatOpened(
            message,
            getConversationType(conversation_type),
            conversation_id
          )
        ) {
          unreadDetails = {
            bench_conversation: `${message.conversationable_type}${
              message.conversationable_type === 'Profile'
                ? message.sender_id
                : message.conversationable_id
            }`,
            messages: [message],
          };
          this.unreadMessages.push(unreadDetails);
          return;
        }
        if (
          !isMessageBelongsToChatOpened(
            message,
            getConversationType(conversation_type),
            conversation_id
          )
        ) {
          unreadDetails.messages.push(message);
        }
      },
      removeMessage(message) {
        const unreadDetails = this.unreadMessages.find(unread_message_detail =>
          getMessageBelongsToUnreadChat(message, unread_message_detail)
        );
        const messages = unreadDetails.messages;
        const findMessageIndex = messages.findIndex(
          element => element.id === message.id
        );
        if (findMessageIndex != -1) {
          messages.splice(findMessageIndex, 1);
        }
      },
      markedChatAsRead(conversationable_type, conversationable_id) {
        const unreadDetails = this.unreadMessages.find(
          detail =>
            detail.bench_conversation ===
            `${getConversationType(
              conversationable_type
            )}${conversationable_id}`
        );
        if (unreadDetails) {
          unreadDetails.messages = [];
        }
      },
      getOldestMessageId(conversationable_type, conversationable_id) {
        const unreadDetails = this.unreadMessages.find(
          m =>
            m.bench_conversation ===
            `${getConversationType(
              conversationable_type
            )}${conversationable_id}`
        );
        if (unreadDetails) {
          if (unreadDetails.messages.length !== 0) {
            return unreadDetails.messages[0].id;
          }
        }
        return null;
      },
    },
  });

  return unreadStore();
};
