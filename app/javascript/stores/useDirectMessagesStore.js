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
      if (!this.checkDuplication(this.directMessagesList, member)) {
        this.directMessagesList.push(member);
        this.sortDMList();
      }
    },
    checkDuplication(array, member) {
      for (const i in array) {
        if (array[i].id == member.id) {
          return true;
        }
      }
      return false;
    },
    async getDmList(workspace_id) {
      try {
        this.directMessagesList = await getDirectMessagesList(workspace_id);
        this.sortDMList();
      } catch (e) {
        console.error(e);
      }
    },
    sortDMList() {
      this.directMessagesList = this.directMessagesList.sort(
        (currUser, nextUser) => {
          if (
            currUser.username.toLowerCase() < nextUser.username.toLowerCase()
          ) {
            return -1;
          }
          if (
            currUser.username.toLowerCase() > nextUser.username.toLowerCase()
          ) {
            return 1;
          }
          return 0;
        }
      );
    },
  },
});
