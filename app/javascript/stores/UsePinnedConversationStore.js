import { defineStore } from 'pinia';
import { pinnedMessages } from '../api/messages/pinnedMessages';
export const usePinnedConversation = defineStore('pinnedConversationStore', {
  state: () => ({
    pinnedConversation: [],
    pinToggle: false,
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
      this.pinnedConversation = await pinnedMessages(conversation_type, id);
    },
    pinMessage(message) {
      this.pinnedConversation.push(message);
    },
    isPinned(message) {
      return this.pinnedConversation.includes(p => p.message == message);
    },
    unPinMessage(message) {
      this.pinnedConversation = this.pinnedConversation.filter(
        msg => msg !== message
      );
    },
    togglePin() {
      this.pinToggle = !this.pinToggle;
    },
  },
});
