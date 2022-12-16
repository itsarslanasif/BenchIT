import { defineStore } from 'pinia';
import { getMessageHistory } from '../modules/socket/messageHistory';

export const useMessageStore = () => {
  const messageStore = defineStore('messages', {
    state: () => {
      return {
        messages: [],
        currMessage: null
      };
    },

    getters: {
      getMessages: state => state.messages,
      repliesCount: state => state.messages?.find(m => m.id == state.currMessage?.id).replies?.length
    },

    actions: {
      async index(conversation_type, id) {
        this.messages = await getMessageHistory(conversation_type, id);
      },
      async addMessage(msg) {
        this.messages.push(msg);
      },
    },
  });

  return messageStore();
};
