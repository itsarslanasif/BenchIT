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
      async getMentionsFromIds(str) {
        const regex = /&lt;\s*@(\d+)\s*&gt;/g;
        const ids = [];
        let match;
        while ((match = regex.exec(str)) !== null) {
          ids.push(match[1]);
        }
        const profiles = await Promise.all(
          ids.map(id => this.getProfileById(id))
        );
        const replacedStr = ids.reduce((acc, id, index) => {
          const profile = profiles[index];
          if (profile) {
            const { username } = profile;
            const mention = document.createElement('span');
            mention.classList.add('mention');
            mention.style.backgroundColor = 'yellow';
            mention.innerText = `@${username}`;
            mention.onclick = () => {
              // function to call on click
            };
            mention.onmouseover = () => {
              // function to call on hover
            };
            const regex = new RegExp(`&lt;@${id}&gt;`, 'g');
            acc = acc.replace(regex, mention.outerHTML);
          }
          return acc;
        }, str);
        return { profiles, replacedStr };
      },          
      getProfileById(id) {
        return this.profiles.find((profile)=>{
          return profile.id == id
        })
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
          currentProfileStore.currentProfile = profile;
          userProfileStore.setUserProfile(profile);
          let index = this.profiles.findIndex(profile => profile.id === currentProfileStore.currentProfile.id);
          this.profiles[index] = profile;
          encryption(sessionStorage, 'currentProfile', profile);
        } catch (e) {
          console.error(e);
        }
      },
    },
  });
  const store = profileStore();

  return store;
};
