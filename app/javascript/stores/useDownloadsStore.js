import { defineStore } from 'pinia';
import { CONSTANTS } from '../assets/constants';

export const useDownloadsStore = () => {
  const downloadsStore = defineStore('downloadsStore', {
    state: () => ({
      downloads: [],
      response: null,
      message: '',
      downloadAlert: false,
    }),

    getters: {
      getDownloads: state => state.downloads,
      getResponse: state => state.response,
    },
    actions: {
      getMessage() {
        if (this.response.data === CONSTANTS.DOWNLOAD_REMOVED) {
          return CONSTANTS.DOWNLOAD_DELETE;
        } else if (this.response.data === CONSTANTS.DOWNLOADS_REMOVED) {
          return CONSTANTS.DOWNLOADS_DELETE;
        } else {
          return CONSTANTS.DOWNLOAD_SUCCESS;
        }
      },
    },
  });

  return downloadsStore();
};
