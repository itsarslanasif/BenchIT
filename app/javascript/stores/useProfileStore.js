import { defineStore } from 'pinia';
import { getAllProfiles } from '../api/profiles/profiles';

export const useProfileStore = () => {
  const profileStore = defineStore('profileStore', {
    state: () => ({
      profiles: [],
    }),

    getters: {
      getProfiles: state => state.profiles,
    },

    actions: {
      async index() {
        this.profiles = await getAllProfiles()
      },
    },
  });
  const store = profileStore();

  return store;
};
