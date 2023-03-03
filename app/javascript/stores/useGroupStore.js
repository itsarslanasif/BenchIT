import { defineStore } from 'pinia';
import { getGroups } from '../api/groups/groups';
export const useGroupStore = defineStore('useGroupStore', {
  state: () => ({
    groups: [],
  }),

  actions: {
    async index() {
      this.groups = await getGroups()
    },
  },
});
