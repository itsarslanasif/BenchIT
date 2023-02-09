import { defineStore } from 'pinia';
import { getDirectMessagesList } from '../api/directMessages/directMessages';

export const useDirectMessagesStore = defineStore('useDirectMessagesStore', {
  state: () => ({
    directMessageUsers: [],
  }),

  actions: {
    appendToDirectMessagesList(member) {
      if (!this.checkDuplication(this.directMessageUsers, member)) {
        this.directMessageUsers.push(member);
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
        this.directMessageUsers = await getDirectMessagesList(workspace_id);
      } catch (e) {
        console.error(e);
      }
    },
    updateProfileStatus(profile) {
      let index = this.directMessageUsers.findIndex(
        element => element.id == profile.id
      );
      if (index !== -1) {
        this.directMessageUsers[index].status = profile.status;
        this.directMessageUsers[index].is_active = profile.is_active;
      }
    },
    getSortedDMList(currentProfileID) {
      const myChat = this.getMyChat(currentProfileID);
      if (myChat) {
        const index = this.getIndexOfMyChat(myChat);
        this.removeMyChatFromList(index);
      }
      if (this.hasElementsToSort()) {
        this.sort();
      }
      if (myChat) {
        this.addMyChatAtTop(myChat);
      }
      return this.directMessageUsers;
    },
    getMyChat(currentProfileID) {
      const myChat = this.directMessageUsers.find(
        conversation => conversation.id === currentProfileID
      );
      return myChat ? myChat : null;
    },
    getIndexOfMyChat(myChat) {
      return this.directMessageUsers.indexOf(myChat);
    },
    removeMyChatFromList(index) {
      this.directMessageUsers.splice(index, 1);
    },
    hasElementsToSort() {
      return this.directMessageUsers.length > 1;
    },
    sort() {
      this.directMessageUsers = this.directMessageUsers.sort(
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
    addMyChatAtTop(myChat) {
      this.directMessageUsers.unshift(myChat);
    },
  },
});
