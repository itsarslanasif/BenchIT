import { defineStore } from 'pinia';
import { getAllProfiles, updateCurrentProfile } from '../api/profiles/profiles';
import { useCurrentProfileStore } from './useCurrentProfileStore';

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
          console.error(e);
        }
      },
      updateProfileStatus(data) {
        let index = this.profiles.findIndex(profile => data.id === profile.id);
        if (index !== -1) {
          this.profiles[index].status = data.status;
          this.profiles[index].is_active = data.is_active;
        }
      },
      async updateProfile(data) {
        const currentProfileStore = useCurrentProfileStore();
        try {
          const profile = await updateCurrentProfile(
            currentProfileStore.currentProfile.workspace_id,
            currentProfileStore.currentProfile.id,
            data
          );
          currentProfileStore.setProfile(profile)
        } catch (e) {
          console.error(e);
        }
      },
    },
  });
  const store = profileStore();

  return store;
};
