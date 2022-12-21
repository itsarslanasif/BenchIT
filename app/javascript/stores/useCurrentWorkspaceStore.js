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
      setWorkspace(Workspace) {
        this.currentWorkspace = Workspace;
      },
    },
  });
  const store = currentWorkspaceStore();

  return store;
};
