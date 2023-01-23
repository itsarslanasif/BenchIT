import { defineStore } from 'pinia';

export const useCurrentWorkspaceStore = defineStore('useCurrentWorkspaceStore', {
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
