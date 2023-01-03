import { defineStore } from 'pinia';

export const useUserProfileStore = defineStore('userProfileStore', {
  state: () => ({
    userProfile: {},
  }),

  actions: {
    setUserProfile(userProfile) {
      this.userProfile = userProfile;
    },
  },
});
