import { defineStore } from 'pinia';
import { useMessageStore } from './useMessagesStore'

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
        if (status) {
          const messageStore = useMessageStore()
          messageStore.sendAllUnsentMessages();
        }
      }
    },
  });

  return connectionStore();
};
