import { defineStore } from 'pinia';

export const useConnectionStore = () => {
  const connectionStore = defineStore('useConnectionStore', {
    state: () => ({
      isConnected: window.navigator.onLine,
    }),

    getters: {
      getConnectionStatus: state => state.isConnected,
    },

    actions: {
      toggleConnection(status) {
        this.isConnected = status;
      }
    },
  });

  return connectionStore();
};
