import { defineStore } from 'pinia';
import { getUnreadMessages } from '../api/notification';

export const useUnreadStore = () => {
  const unreadStore = defineStore('useUnreadStore', {
    state: () => {
      return {
        unreadMessages: {},
      };
    },

    actions: {
      async index() {
        this.unreadMessages = await getUnreadMessages()
      },
    },
  });

  return unreadStore();
};
