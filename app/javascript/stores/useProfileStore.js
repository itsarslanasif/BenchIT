import { defineStore } from 'pinia';
import { getAllProfiles } from '../api/profiles/profiles';
import { useCurrentProfileStore } from './useCurrentProfileStore';
import { useErrorStore } from './useErrorStore';

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
        try {
          this.profiles = await getAllProfiles(
            currentProfileStore.currentProfile.workspace_id
          );
        } catch (e) {
          this.handleError(e.response.data.error)
        }
      },
      handleError(error) {
        useErrorStore().showError(error) 
      },
      updateProfileStatus(data) {
        let index = this.profiles.findIndex(profile => data.id === profile.id);
        if (index !== -1) {
          this.profiles[index].status = data.status;
          this.profiles[index].is_active = data.is_active;
        }
      },
    },
  });
  const store = profileStore();

  return store;
};
