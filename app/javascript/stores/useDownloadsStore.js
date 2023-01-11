import { defineStore } from 'pinia';

export const useDownloadsStore = () => {
  const downloadsStore = defineStore('downloadsStore', {
    state: () => ({
      downloads: [],
    }),

    getters: {
      getDownloads: state => state.downloads,
    },
  });

  return downloadsStore();
};