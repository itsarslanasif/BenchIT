import { defineStore } from 'pinia';

export const useRightPaneThreadStore = defineStore('RightPanethreadStore', {
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
