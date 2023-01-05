import { defineStore } from 'pinia';

export const useThreadStore = defineStore('threadStore', {
  state: () => ({
    message: {},
  }),

  getters: {
    getMessages: state => state.message,
  },

  actions: {
    setMessage(message) {
      this.message = message;
    },
  },
});
