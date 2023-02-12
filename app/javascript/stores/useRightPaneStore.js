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
      if (val) {
        this.pane1.showThread = false;
        this.pane1.showUserProfile = val;
      } else {
        this.pane1.showThread = val;
        this.pane1.showUserProfile = val;
      }
    },
    toggleThreadShow(val) {
      if (val) {
        this.pane1.showThread = val;
        this.pane1.showUserProfile = false;
      } else {
        this.pane1.showThread = val;
        this.pane1.showUserProfile = val;
      }
    },
    toggleRightPaneThreadShow(val) {
      if (val) {
        this.pane2.showThread = val;
        this.pane2.showUserProfile = false;
      } else {
        this.pane2.showThread = val;
        this.pane2.showUserProfile = val;
      }
    },
    toggleRightPaneUserProfileShow(val) {
      if (val) {
        this.pane2.showThread = false;
        this.pane2.showUserProfile = val;
      } else {
        this.pane2.showThread = val;
        this.pane2.showUserProfile = val;
      }
    },
    toggleChatShow(val) {
      if (val) {
        this.pane2.showUserProfile = false;
        this.pane2.showThread = false;
        this.pane1.useMe = val;
        this.pane2.showChat = val;
      }
      this.pane2.showChat = val;
      this.pane1.useMe = val;
    },
  },
});
