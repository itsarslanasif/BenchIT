import { defineStore } from 'pinia';

export const useCurrentWorkspaceStore = () => {
  const currentWorkspaceStore = defineStore('currentWorkspaceStore', {
    state: () => ({
      currentWorkspace: {
        id: 1,
      },
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
