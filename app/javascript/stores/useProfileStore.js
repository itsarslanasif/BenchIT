import { defineStore } from 'pinia';
import { getAllProfiles } from '../api/profiles/profiles';
import { useCurrentProfileStore } from './useCurrentProfileStore';
import { useCurrentWorkspaceStore } from './useCurrentWorkspaceStore';

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
        const currentProfileStore = useCurrentProfileStore();
        this.profiles = await getAllProfiles(
          currentProfileStore.currentProfile.workspace_id
        );
      },
    },
  });
  const store = profileStore();

  return store;
};
