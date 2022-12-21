import { defineStore } from 'pinia';

export const useCurrentProfileStore = () => {
  const currentProfileStore = defineStore('currentProfileStore', {
    state: () => ({
      currentProfile: {
        id: 1,
        username: 'Alva',
        description: 'ASE',
        workspace_id: 1,
        user_id: 1,
      },
    }),

    getters: {
      getCurrentProfile: state => state.currentProfile,
    },

    actions: {
      setProfile(Profile) {
        this.currentProfile = Profile;
      },
    },
  });
  const store = currentProfileStore();

  return store;
};
