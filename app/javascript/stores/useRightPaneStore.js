import { defineStore } from 'pinia';

export const useRightPaneStore = defineStore('useRightPaneStore', {
  state: () => ({
    showUserProfile: false,
    showThread: false,
    showSplitView: false,
    rightPaneSelectedChat: {}
  }),

  getters: {
    getRightSelectedChat: state => state.rightPaneSelectedChat
  },

  actions: {
    toggleUserProfileShow(val) {
      if (val) {
        this.showThread = false;
        this.showSplitView = false;
      }
      this.showUserProfile = val;
    },
    toggleThreadShow(val) {
      if (val) {
        this.showUserProfile = false;
        this.showSplitView = false;
      }
      this.showThread = val;
    },
    toggleViewSplitShow(val) {
      if (val) {
        this.showUserProfile = false;
        this.showThread = false;
      }
      this.showSplitView = val;
    },
    setRightPaneSelectedChat(val, type) {
      this.rightPaneSelectedChat = val
      this.rightPaneSelectedChat.conversation_type = type
    }
  },
});
