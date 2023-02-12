import { defineStore } from 'pinia';

export const useRightPaneUserProfileStore = defineStore('rightPaneUserProfileStore', {
  state: () => ({
    userProfile: {},
  }),

  actions: {
    setUserProfile(userProfile) {
      this.userProfile = userProfile;
    },
  },
});
