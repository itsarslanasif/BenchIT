import { defineStore } from 'pinia';
export const useUserProfileStore = defineStore('userProfileStore', {
  state: () => ({
    user_profile: {},
  }),

  actions: {
    setUserProfile(user_profile) {
      this.user_profile = user_profile;
    },
  },
});
