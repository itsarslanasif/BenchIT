import {
  defineStore
} from 'pinia';

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
    pinMessage(message) {
      this.pinnedConversation.push(message);
    },
    isPinned(message) {
      if (this.pinnedConversation.includes(message)) {
        return true
      }
    },
    unPinMessage(message) {
      this.pinnedConversation = this.pinnedConversation.filter(function (item) {
        return item !== message
      })
    },
    togglePin() {
      this.pinToggle = !this.pinToggle;
      console.log("asaishiwehiuuwehcwncinwecninwecniunewc:",this.pinToggle)
    }
  },
});
