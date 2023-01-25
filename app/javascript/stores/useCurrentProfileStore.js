import {
  defineStore
} from 'pinia';

import { encryption } from '../modules/crypto/crypto'

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
      setProfileStatus(status) {
        this.currentProfile.status = status
        encryption(sessionStorage,'currentProfile',this.currentProfile)
      },
      setProfileActiveStatus(is_active){
        this.currentProfile.is_active=is_active
        encryption(sessionStorage,'currentProfile',this.currentProfile)
      }
    },
  });
  const store = currentProfileStore();

  return store;
};
