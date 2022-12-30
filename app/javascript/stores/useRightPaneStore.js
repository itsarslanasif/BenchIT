import { defineStore } from 'pinia';
export const useRightPaneStore = defineStore('useRightPaneStore', {
  state: () => ({
    showUserProfile: false,
    showThread: false,
  }),

  actions: {
    toggleUserProfileShow(val) {
      if (val) {
        this.showThread = false;
      }
      this.showUserProfile = val;
    },
    toggleThreadShow(val) {
      if (val) {
        this.showUserProfile = false;
      }
      this.showThread = val;
    },
  },
});
