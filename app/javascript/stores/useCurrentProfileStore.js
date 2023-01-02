import { defineStore } from 'pinia';

export const useCurrentProfileStore = () => {
  const currentProfileStore = defineStore('currentProfileStore', {
    state: () => ({
      currentProfile: {},
    }),

    getters: {
      getCurrentProfile: state => state.currentProfile,
    },

    actions: {
      setProfile(user) {
        this.currentProfile = user.profile;
      },
    },
  });
  const store = currentProfileStore();

  return store;
};
