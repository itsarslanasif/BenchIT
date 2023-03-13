import { defineStore } from 'pinia';
import { pinnedMessages } from '../api/messages/pinnedMessages';
import { useErrorStore } from './useErrorStore';

export const usePinnedConversation = defineStore('pinnedConversationStore', {
  state: () => ({
    pinnedConversation: [],
    pinToggle: false,
    showAlert: false,
  }),

  getters: {
    getPinnedConversation() {
      return this.pinnedConversation;
    },
    getCount() {
      return this.pinnedConversation.length;
    },
    getPinToggle() {
      return this.pinToggle;
    },
  },

  actions: {
    async index(conversation_type, id) {
      try {
      this.pinnedConversation = await pinnedMessages(conversation_type, id);
      this.pinToggle = false;
      }
      catch (error) {
        this.handleError(error.response.data.error)

      }
    },
    pinMessage(message) {
      this.pinnedConversation.push(message);
    },
    isPinned(message) {
      return this.pinnedConversation.includes(message);
    },
    unPinMessage(message) {
      const index = this.pinnedConversation.findIndex(m => m.id === message.id);

      if (index != -1) {
        this.pinnedConversation.splice(index, 1);
      }
    },
    togglePin() {
      this.pinToggle = !this.pinToggle;
    },
    closeModal() {
      this.pinToggle = false;
    },
    handleError(error) {
      useErrorStore().showError(error) 
    },
  },
});
