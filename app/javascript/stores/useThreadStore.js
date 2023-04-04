import { defineStore } from 'pinia';

export const useThreadStore = defineStore('threadStore', {
  state: () => ({
    message: {},
    threads: [],
  }),

  getters: {
    getMessage: state => state.message,
    getThreads: state => state.threads,
  },

  actions: {
    setMessage(message) {
      this.message = message;
    },
    setThreads(threads) {
      this.threads = threads;
    },
  },
});
