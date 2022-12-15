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
        this.recentFiles = await getAllRecentAttachments()
      },
    },
  });
  const store = recentFilesStore();

  return store;
};
