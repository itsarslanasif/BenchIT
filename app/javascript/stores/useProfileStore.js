import { defineStore } from 'pinia';
import { getAllProfiles, updateCurrentProfile } from '../api/profiles/profiles';
import { useCurrentProfileStore } from './useCurrentProfileStore';
import { useUserProfileStore } from './useUserProfileStore';
import { encryption } from '../modules/crypto/crypto';

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
        const userProfileStore = useUserProfileStore();
        try {
          const profile = await updateCurrentProfile(
            currentProfileStore.currentProfile.workspace_id,
            currentProfileStore.currentProfile.id,
            data
          );
          // console.log(profile)
          currentProfileStore.currentProfile = profile;
          userProfileStore.setUserProfile(profile);
          let index = this.profiles.findIndex(profile => profile.id === currentProfileStore.currentProfile.id);
          this.profiles[index] = profile;
          encryption(sessionStorage, 'currentProfile', profile);
        } catch (e) {
          debugger
          console.error(e);
        }
      },
    },
  });
  const store = profileStore();

  return store;
};
