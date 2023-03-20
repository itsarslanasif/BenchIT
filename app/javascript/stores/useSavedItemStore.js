import { defineStore } from 'pinia';
import { getSaveMessages } from '../api/save_messages/savemessages';
import { errorHandler } from '../views/widgets/messageProvider';

export const useSavedItemsStore = defineStore('savedItem', {
  state: () => ({
    savedItems: [],
  }),
  actions: {
    async index() {
      try {
        this.savedItems = await getSaveMessages();
      } catch (e) {
        this.handleError(e.response.data.message);
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
    handleError(error) {
      errorHandler(error.response.data.message);
    },
  },
});
