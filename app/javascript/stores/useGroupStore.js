import { defineStore } from 'pinia';
import { getGroups } from '../api/groups/groups';
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
      return this.groups.map(obj => {
        if (obj.id === group.id) {
          let index = this.groups.indexOf(obj);
          if (group.profile_ids.length != this.groups[index].profiles.length) {
            this.groups[index] = group;
          }
        }
        return obj;
      });
    },
  },
});
