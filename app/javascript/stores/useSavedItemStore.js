import { defineStore } from 'pinia'

export const useSavedItemsStore = defineStore('savedItem', {
  state: () => {
    return {
      savedItems: [],
    }
  },
  actions: {
    addSavedItem(item) {
      this.savedItems.push(item);
    },
    removeSavedItem(item) {
      const index = this.savedItems.indexOf(item);
      if (index > -1) {
        this.savedItems.splice(index, 1);
      }
    }
  }
})
