import { defineStore } from 'pinia';

export const useCurrentWorkspaceStore = () => {
  const currentWorkspaceStore = defineStore('currentWorkspaceStore', {
    state: () => ({
      currentWorkspace: {},
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
  const store = currentWorkspaceStore();

  return store;
};
