import { defineStore } from 'pinia';

export const useShortcutAttachmentStore = defineStore('useShortcutAttachmentStore', {
  state: () => ({
    showCreateTextSnippitModal:false
  }),
  actions: {
    toggleShowCreateTextSnippitModal() {
      this.showCreateTextSnippitModal = !this.showCreateTextSnippitModal;
    },
  },
});
