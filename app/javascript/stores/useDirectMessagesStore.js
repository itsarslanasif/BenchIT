import { defineStore } from 'pinia';
import { getDirectMessagesList } from '../api/directMessages/directMessages';

export const useDirectMessagesStore = defineStore('useDirectMessagesStore', {
  state: () => ({
    directMessagesList: [],
  }),

  actions: {
    appendToDirectMessagesList(member) {
      if (!this.checkDuplication(this.directMessagesList, member)) {
        this.directMessagesList.push(member);
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
      } catch (e) {
        console.error(e);
      }
    },
    updateProfileStatus(profile) {
      let index = this.directMessagesList.findIndex(
        element => element.id == profile.id
      );
      if (index != -1){
         this.directMessagesList[index].status = profile.status;
         this.directMessagesList[index].is_active=profile.is_active
        }
    },
    getSortedDMList(currentProfileID) {
      const ownChat = this.getOwnChat(currentProfileID);
      const index = this.getIndexOfOwnChat(ownChat);
      this.removeOwnChatFromList(index);
      if (this.hasElementsToSort()) {
        this.sort();
      }
      this.addOwnChatAtTop(ownChat);
      return this.directMessagesList;
    },
    getOwnChat(currentProfileID) {
      return this.directMessagesList.find(chat => chat.id === currentProfileID);
    },
    getIndexOfOwnChat(ownChat) {
      return this.directMessagesList.indexOf(ownChat);
    },
    removeOwnChatFromList(index) {
      this.directMessagesList.splice(index, 1);
    },
    hasElementsToSort() {
      return this.directMessagesList.length > 1;
    },
    sort() {
      this.directMessagesList = this.directMessagesList.sort(
        (thisUser, nextUser) => {
          if (
            thisUser.username.toLowerCase() < nextUser.username.toLowerCase()
          ) {
            return -1;
          }
          if (
            thisUser.username.toLowerCase() > nextUser.username.toLowerCase()
          ) {
            return 1;
          }
          return 0;
        }
      );
    },
    addOwnChatAtTop(ownChat) {
      this.directMessagesList.unshift(ownChat);
    },
  },
});
