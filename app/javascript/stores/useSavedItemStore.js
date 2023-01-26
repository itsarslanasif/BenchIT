import { defineStore } from 'pinia'
import { getSaveMessages } from '../api/save_messages/savemessages'

export const useSavedItemsStore = defineStore('savedItem', {
  state: () => {
    return {
      savedItems: [],
    }
  },
  actions: {
    async index() {
      try {
        this.savedItems = await getSaveMessages();
      } catch (e) {
        console.error(e);
      }
    },
    addSavedItem(item) {
      this.savedItems.push(item);
    },
    removeSavedItem(payload) {
      this.savedItems = this.savedItems.filter((item) => (item.message.id !== payload.message.id && item.profile.id !== payload.profile.id))
    }
  }
})
