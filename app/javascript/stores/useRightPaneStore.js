import { defineStore } from 'pinia';

export const useRightPaneStore = defineStore('useRightPaneStore', {
  state: () => ({

    pane1: {
      useMe: false,
      showChat: false,
      showThread: false,
      showUserProfile: false
    },
    pane2: {
      dontUseMe: false,
      showMe: false,
      showChat: false,
      showThread: false,
      showUserProfile: false
    }
  }),

  actions: {
    toggleUserProfileShow(val) {
      if (val) {
        console.log('1st if')
        this.pane2.showMe = val
        this.pane2.showUserProfile = val
        this.pane2.showThread = false
      }
      if (val && this.pane2.showChat) {
        console.log('2nd if')
        this.pane2.showUserProfile = val;
        this.pane2.showChat = false;
        this.pane2.showThread = false;
        this.pane1.showThread = false
        this.pane2.dontUseMe = true
        this.pane2.showChat = false
      }
      else if (val && this.pane1.useMe) {
        console.log('3rd if')
          this.pane1.showUserProfile = val
          this.pane2.showUserProfile ?
          this.pane2.showUserProfile = !val
          :
          null
      }
      this.pane2.showMe = val;
      this.pane2.showUserProfile = val;
      this.pane1.showUserProfile = val;
    },

    toggleThreadShow(val) {
      if (val) {
        console.log('opens first thread')
        this.pane2.showMe = val
        this.pane2.showThread = val
        this.pane2.showUserProfile = false
      }
      if (val && this.pane2.showChat) {
        console.log('open 2nd pane thread')
        this.pane2.showUserProfile = false;
        this.pane2.showChat = false;
        this.pane2.showThread = val
        this.pane1.showThread = false
        this.pane2.dontUseMe = true
        this.pane2.showChat = false
        // this.pane1.useMe = true;
      }
      else if (val && this.pane1.useMe) {
        console.log('3rd if')
          this.pane1.showThread = val
          this.pane2.showThread ?
          this.pane2.showThread = !val
          :
          null
      }
      // if (val && this.pane1.useMe) {
      //   console.log('4th if')
      //   this.pane1.showThread = val
      // }
      //   else if (!this.pane1.useMe) {
      //     console.log('2nd if')
      //     this.pane1.showThread = val
      //     // this.pane1.showChat = false
      //     // this.pane1.showUserProfile = false
      //   }
      //   else if (this.pane1.useMe) {
      //     console.log('3rd if')
      //     this.pane1.showThread = val
      //     this.pane1.showChat = val
      //     // this.pane2.showThread = false
      //     // this.pane1.useMe = false;
      //     // this.pane2.showThread = val
      //     // this.pane1.showChat = false
      //     // this.pane1.showUserProfile = false
      //   }
      // }
      if (!val) {
          this.pane1.showThread = val;
          this.pane2.showThread = val;
          this.pane1.useMe = val;
          this.pane2.showMe = val;
          this.pane1.showChat = false;
        }
    },
    toggleChatShow(val) {
      if (val) {
        this.pane2.showUserProfile = false;
        this.pane2.showThread = false;
        this.pane1.useMe = val;
        this.pane2.showChat = val;
      }
      this.pane2.showMe = val;
      this.pane2.showChat = val;
      this.pane1.useMe = val;
    },
  },
});
