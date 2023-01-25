import { defineStore } from 'pinia';

export const useThreadStore = defineStore('threadStore', {
  state: () => ({
    message: {},
  }),

  getters: {
    getMessage: state => state.message,
  },

  actions: {
    setMessage(message) {
      this.message = message;
    },
  },
});
