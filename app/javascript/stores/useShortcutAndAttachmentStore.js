import { defineStore } from 'pinia';

export const useShortcutAndAttachmentStore = defineStore('useShortcutAndAttachmentStore', {
  state: () => ({
    showCreateTextSnippitModal:false,
    showModalInChat:false,
    showModalInThread:false,
  }),
  actions: {
    toggleShowCreateTextSnippitModal() {
      this.showCreateTextSnippitModal = !this.showCreateTextSnippitModal;
    },
    toggleModalInChat(){
      this.showModalInChat= !this.showModalInChat
    },
    toggleModalInThread(){
      this.showModalInThread= !this.showModalInThread
    }
  },
});
