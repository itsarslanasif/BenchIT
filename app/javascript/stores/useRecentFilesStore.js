import { defineStore } from 'pinia';
import { getAllRecentAttachments } from '../api/attachments/attachments';
import { useErrorStore } from './useErrorStore';

export const useRecentFilesStore = () => {
  const recentFilesStore = defineStore('recentFilesStore', {
    state: () => ({
      recentFiles: [],
      showModalInChat: false,
      showModalInThread: false,
    }),

    getters: {
      getRecentFiles: state => state.recentFiles,
    },

    actions: {
      async index() {
        try {
          this.recentFiles = await getAllRecentAttachments();
        } catch (e) {
          this.handleError(e.response.data.error)
        }
      },
      toggleModalInChat() {
        this.showModalInChat = !this.showModalInChat;
      },
      toggleModalInThread() {
        this.showModalInThread = !this.showModalInThread;
      },
      handleError(error) {
        useErrorStore().showError(error) 
      },
    },
  });
  const store = recentFilesStore();

  return store;
};
