import { defineStore } from 'pinia';
import { getRecentStatuses } from '../api/profiles/profileStatus';
import { deleteRecentStatus } from '../api/profiles/profileStatus';
import { useErrorStore } from './useErrorStore';

export const useProfileStatusStore = defineStore('ProfileStatusStore', {
  state: () => ({
    showProfileStatusPopUp: false,
    showProfileStatusPopUpSubModel: false,
    recent_statuses: [],
    workspace_statuses: [],
  }),
  actions: {
    async getChannelMembers(query, bench_channel_id) {
      try {
      this.channelMembers = await getChannelMembers(query, bench_channel_id);
      } catch (e) {
        this.handleError(e.response.data.error)
      }
    },
    toggleProfileStatusPopUp() {
      this.showProfileStatusPopUp = !this.showProfileStatusPopUp;
    },
    setRecentAndWorkspaceStatus() {
      getRecentStatuses()
        .then(response => {
          this.recent_statuses = response.recent_statuses;
          this.workspace_statuses = response.workspace_statuses;
        })
        .catch(e => this.handleError(e.response.data.error));
    },
    deleteRecentStatus(id) {
      deleteRecentStatus(id)
        .then(response => {
          this.setRecentAndWorkspaceStatus();
        })
        .catch(e => this.handleError(e.response.data.error));
    },
    handleError(error) {
      useErrorStore().showError(error) 
    }
  },
});
