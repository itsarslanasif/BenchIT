import { defineStore } from 'pinia';
import { getDirectMessagesList } from '../api/directMessages/directMessages';

export const useDirectMessagesStore = defineStore('useDirectMessagesStore', {
  state: () => ({
    selectedDm: '',
    directMessagesList: [],
  }),

  getters: {
    getSelectedDm() {
      return this.selectedDm;
    },
  },
  actions: {
    setSelectedDm(selectedDm) {
      this.selectedDm = selectedDm;
    },
    appendToDirectMessagesList(member) {
      this.directMessagesList.push(member);
    },
    async getDmList(workspace_id) {
      this.directMessagesList = await getDirectMessagesList(workspace_id);
    },
  },
});
