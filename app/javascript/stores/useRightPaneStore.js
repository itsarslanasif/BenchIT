import { defineStore } from 'pinia';
export const useRightPaneStore = defineStore('useRightPaneStore', {
  state: () => ({
    showUserProfile: false,
    showThread: false,
  }),

  actions: {
    toggleUserProfileShow(val) {
      if (val == true) {
        this.showThread = false;
      }
      this.showUserProfile = val;
    },
    toggleThreadShow(val) {
      if (val == true) {
        this.showUserProfile = false;
      }
      this.showThread = val;
    },
  },
});
