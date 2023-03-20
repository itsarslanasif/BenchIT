import { defineStore } from 'pinia';
import { getAllRecentAttachments } from '../api/attachments/attachments';
import { errorHandler } from '../views/widgets/messageProvider';

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
          this.handleError(e.response.data.message);
        }
      },
      toggleModalInChat() {
        this.showModalInChat = !this.showModalInChat;
      },
      toggleModalInThread() {
        this.showModalInThread = !this.showModalInThread;
      },
      handleError(error) {
        errorHandler(error.response.data.message);
      },
    },
  });
  const store = recentFilesStore();

  return store;
};
