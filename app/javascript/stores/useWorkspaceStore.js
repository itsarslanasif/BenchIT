import { defineStore } from 'pinia';
import {
  fetchJoinedWorkspaces,
  createWorkspace,
} from '../api/workspaces/workspacesApi';
import { errorHandler } from '../views/widgets/messageProvider';

export const useWorkspaceStore = defineStore('useWorkspaceStore', {
  state: () => ({
    workspaces: [],
    joinedWorkspaces: [],
  }),

  getters: {
    getWorkspaces: state => state.workspaces,
    getJoinedWorkspaces: state => state.joinedWorkspaces,
  },

  actions: {
    async index() {
      try {
        this.joinedWorkspaces = await fetchJoinedWorkspaces();
      } catch (e) {
        errorHandler(e.response.data.message);
      }
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
        const workspace = await createWorkspace(params);
        this.joinedWorkspaces = [
          ...this.joinedWorkspaces,
          workspace.data.workspace,
        ];
      } catch (e) {
        errorHandler(e.response.data.message);
        return e;
      }
    },
  },
});
