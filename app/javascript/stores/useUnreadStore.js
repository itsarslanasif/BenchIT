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
      addNewMessage(message) {
        const unreadDetails = this.unreadMessages.find(m => {
          if (message.conversationable_type === 'Profile') {
            if (
              m.bench_conversation ===
              `${message.conversationable_type}${message.sender_id}`
            ) {
              return m;
            }
          } else {
            if (
              m.bench_conversation ===
              `${message.conversationable_type}${message.conversationable_id}`
            ) {
              return m;
            }
          }
        });
        unreadDetails.messages.push(message);
      },
      removeMessage(message) {
        const unreadDetails = this.unreadMessages.find(m => {
          if (message.conversationable_type === 'Profile') {
            if (
              m.bench_conversation ===
              `${message.conversationable_type}${message.sender_id}`
            ) {
              return m;
            }
          } else {
            if (
              m.bench_conversation ===
              `${message.conversationable_type}${message.conversationable_id}`
            ) {
              return m;
            }
          }
        });
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
          m =>
            m.bench_conversation ===
            `${getConversationType(
              conversationable_type
            )}${conversationable_id}`
        );
        if (unreadDetails) {
          unreadDetails.messages = [];
        }
      },
    },
  });

  return unreadStore();
};
