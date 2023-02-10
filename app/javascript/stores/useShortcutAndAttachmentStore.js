import { defineStore } from 'pinia';

export const useShortcutAndAttachmentStore = defineStore(
  'useShortcutAndAttachmentStore',
  {
    state: () => ({
      showCreateTextSnippitModal: false,
      showCreateTextSnippitModalThread: false,
      showModalInChat: false,
      showModalInThread: false,
    }),
    actions: {
      toggleShowCreateTextSnippitModal() {
        this.showCreateTextSnippitModal = !this.showCreateTextSnippitModal;
      },
      toggleshowCreateTextSnippitModalThread() {
        this.showCreateTextSnippitModalThread = !this.showCreateTextSnippitModalThread;
      },
      toggleModalInChat() {
        this.showModalInChat = !this.showModalInChat;
      },
      toggleModalInThread() {
        this.showModalInThread = !this.showModalInThread;
      },
    },
  }
);
