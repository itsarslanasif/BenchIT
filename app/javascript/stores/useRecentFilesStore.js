import { defineStore } from 'pinia';
import { getAllRecentAttachments } from '../api/attachments/attachments';

export const useRecentFilesStore = () => {
  const recentFilesStore = defineStore('recentFilesStore', {
    state: () => ({
      recentFiles: [],
    }),

    getters: {
      getRecentFiles: state => state.recentFiles,
    },

    actions: {
      async index() {
        try {
          this.recentFiles = await getAllRecentAttachments()
        } catch (e) {
          this.handleError(e)
        }
      },
      handleError(err) {
        this.error = err
      }
    },
  });
  const store = recentFilesStore();

  return store;
};
