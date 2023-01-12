import { defineStore } from 'pinia';
import { getMessageHistory } from '../modules/socket/messageHistory';
import { deleteMessage } from '../api/messages';
import { CONSTANTS } from '../assets/constants';

export const useMessageStore = () => {
  const messageStore = defineStore('messages', {
    state: () => ({     
        messages: [],
        currMessage: [],
        currentPage: 1,
        isLoading: false
    }),

    getters: {
      getMessages: state => state.messages,
      repliesCount: state => {
        if (
          !CONSTANTS.NULL_VALUES.includes(state.messages) &&
          state.currMessage !== null
        ) {
          state.messages.find(m => m.id == state.currMessage.id).replies.length;
        }
      },
    },

    actions: {
      async index(conversation_type, id) {
        this.isLoading = true;
        let newMessages = await getMessageHistory(
          conversation_type.slice(0, -1),
          id,
          this.currentPage
        )
        this.messages =  [...newMessages.messages, ...this.messages]
        this.currentPage += 1
        this.isLoading = false;
      },
      async addMessage(msg) {
        messageStore;
        this.messages.push(msg);
      },
      async deleteMessage(id) {
        await deleteMessage(id);
      },
    },
  });

  return messageStore();
};
