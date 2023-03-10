import { defineStore } from 'pinia';
import { getGroups } from '../api/groups/groups';
import { useProfileStore } from './useProfileStore';
export const useGroupStore = defineStore('useGroupStore', {
  state: () => ({
    groups: [],
  }),

  actions: {
    async index() {
      this.groups = await getGroups();
    },
    isNewGroup(group) {
      if (!this.groups.some(obj => obj.id === group.id)) {
        this.groups.push(group);
      }
    },
    updateGroup(group) {
      const profileStore = useProfileStore();
      let updatedGroup = null;
      this.groups.map(obj => {
        if (obj.id === group.id) {
          let index = this.groups.indexOf(obj);
          this.groups[index].name = group.name;
          this.groups[index].profiles = profileStore.getProfilesByIds(
            group.profile_ids
          );
          this.groups[index].conversation_type = 'Group';
          updatedGroup = this.groups[index];
        }
      });
      return updatedGroup;
    },
    appendUniqueGroup(group) {
      const profileStore = useProfileStore();
      if (!this.checkDuplication(group)) {
        group.profiles = profileStore.getProfilesByIds(group.profile_ids);
        this.groups.push(group);
      }
    },
    checkDuplication(group) {
      return this.groups.some(item => item.id === group.id);
    },
  },
});
