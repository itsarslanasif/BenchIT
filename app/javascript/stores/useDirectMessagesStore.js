import { defineStore } from 'pinia';
import {
  getDirectMessagesList,
  removeChatFromList,
} from '../api/directMessages/directMessages';
import { errorHandler } from '../views/widgets/messageProvider';
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
        this.handleError(e.response.data.message);
      }
    },
    updateProfileStatus(profile) {
      let index = this.directMessageUsers.findIndex(
        element => element.id == profile.id
      );
      if (index !== -1) {
        this.directMessageUsers[index].status = profile.status;
        this.directMessageUsers[index].is_active = profile.is_active;
        this.directMessageUsers[index].username = profile.username;
      }
    },
    async removeChatFromList(chat_id) {
      const index = this.directMessageUsers.findIndex(
        chat => chat.id === chat_id
      );
      this.directMessageUsers.splice(index, 1);
      await removeChatFromList(chat_id);
    },
    getSortedDMList(currentProfileID) {
      const [myProfile, index] = this.getMyProfileWithIndex(currentProfileID);
      if (myProfile) {
        this.removeMyProfileFromList(index);
      }
      if (this.hasElementsToSort()) {
        this.sort();
      }
      if (myProfile) {
        this.addMyProfileAtTop(myProfile);
      }
      return this.directMessageUsers;
    },
    getMyProfileWithIndex(currentProfileID) {
      const index = this.directMessageUsers.findIndex(
        profile => profile.id === currentProfileID
      );
      return [this.directMessageUsers[index], index];
    },
    getIndexOfMyProfile(myProfile) {
      return this.directMessageUsers.indexOf(myProfile);
    },
    removeMyProfileFromList(index) {
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
    addMyProfileAtTop(myProfile) {
      this.directMessageUsers.unshift(myProfile);
    },
    handleError(error) {
      errorHandler(error);
    },
  },
});
