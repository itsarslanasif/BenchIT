import { defineStore } from 'pinia';
import { getAllRecentAttachments } from '../api/attachments/attachments';

export const useRecentFilesStore = () => {
  const recentFilesStore = defineStore('recentFilesStore', {
    state: () => ({
      recentFiles: [],
      showModal:false,
    }),

    getters: {
      getRecentFiles: state => state.recentFiles,
    },

    actions: {
      async index() {
        try {
          this.recentFiles = await getAllRecentAttachments()
        } catch (e) {
          console.error(e)
        }
      },
      toggleModal(){
        this.showModal= !this.showModal
      }
    },
  });
  const store = recentFilesStore();

  return store;
};
