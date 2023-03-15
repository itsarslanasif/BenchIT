import { defineStore } from 'pinia';
import { handleError } from 'vue';
import { createWorkspace } from '../../../app/javascript/api/workspaces/workspacesApi.js';
import { errorHandler } from '../views/widgets/messageProvider';

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
    async createWorkspace(name, type, organization_type, capacity, url) {
      try {
        let params = {
          company_name: name,
          workspace_type: type,
          bench_it_url: url,
          capacity: capacity,
          organization_type: organization_type,
        };
        const new_workspace = await createWorkspace(params);

        return new_workspace;
      } catch (e) {
        errorHandler(e.response.data.message);
      }
    },
  },
});
