import { defineStore } from 'pinia';
export const useThreadStore = defineStore('threadStore', {
  state: () => ({
    showThread: false,
    message: {},
  }),

  actions: {
    toggleShow(val) {
      this.showThread = val;
    },
    setMessage(message) {
      this.message = message;
    },
  },
});
