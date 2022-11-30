import { defineStore } from 'pinia';
import axios from '../modules/axios/index';
import { getMessageHistory } from '../modules/socket/messageHistory';

export const useMessageStore = () => {
  const messageStore = defineStore('messages', {
    state: () => {
      return {
        messages: [],
      };
    },

    getters: {
      getMessages: state => state.messages,
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
