import { defineStore } from 'pinia';

export const useRightPaneStore = defineStore('useRightPaneStore', {
  state: () => ({
    pane1: {
      useMe: false,
      showThread: false,
      showUserProfile: false
    },
    pane2: {
      showChat: false,
      showThread: false,
      showUserProfile: false
    }
  }),

  actions: {
    toggleUserProfileShow(val) {
      this.pane1.showUserProfile = val;
      this.pane1.showThread = val ? false : val;
    },
    toggleThreadShow(val) {
      this.pane1.showThread = val;
      this.pane1.showUserProfile = val ? false : val;
    },
    toggleRightPaneThreadShow(val) {
      this.pane2.showThread = val;
      this.pane2.showUserProfile = val ? false : val;
    },
    toggleRightPaneUserProfileShow(val) {
      this.pane2.showUserProfile = val;
      this.pane2.showThread = val ? false : val;
    },
    toggleChatShow(val) {
      this.pane1.useMe = val;
      this.pane2.showChat = val;
      this.pane2.showUserProfile = false;
      this.pane2.showThread = false;
    },
  },
});
