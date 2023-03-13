import { defineStore } from 'pinia';
import { getSaveMessages } from '../api/save_messages/savemessages';
import { useErrorStore } from './useErrorStore';

export const useSavedItemsStore = defineStore('savedItem', {
  state: () => ({
    savedItems: [],
  }),
  actions: {
    async index() {
      try {
        this.savedItems = await getSaveMessages();
      } catch (e) {
        this.handleError(e.response.data.error)
      }
    },
    addSavedItem(item) {
      this.savedItems.push(item);
    },
    removeSavedItem(currMessage) {
      this.savedItems = this.savedItems.filter(
        item => item.message.id !== currMessage.id
      );
    },
    handleError (e) {
      useErrorStore().showError(e) 
    }
  },
});
