import { defineStore } from 'pinia';

export const useCurrentWorkspaceStore = defineStore('currentWorkspaceStore', {
  state: () => ({
    currentWorkspace: {},
    switchingWorkspace: false,
  }),

  getters: {
    getCurrentWorkspace: state => state.currentWorkspace,
  },

  actions: {
    setWorkspace(workspace) {
      this.currentWorkspace = workspace;
    },
  },
});
