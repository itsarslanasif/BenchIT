import { defineStore } from 'pinia';
import { getAllProfiles } from '../api/profiles/profiles';
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
      getProfileById(id) {
        return this.profiles.find((profile)=>{
          return profile.id = id
        })
      }
    },
  });
  const store = profileStore();

  return store;
};
