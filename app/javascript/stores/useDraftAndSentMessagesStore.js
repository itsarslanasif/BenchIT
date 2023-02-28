import { defineStore } from 'pinia';
import { getSentMessages } from '../api/recentlySent/recentlySentMessages';

export const useDraftAndSentMessagesStore = () => {
  const draftAndSentMessagesStore = defineStore('draftAndSentMessages', {
    state: () => ({
      sentMessages: [],
      draftMessages: [],
      currentPage: 1,
      maxPages: null,
    }),
    getters: {
      getSentMessages: state => state.sentMessages,
      getDraftMessages: state => state.draftMessages,
    },
    actions: {
      async index() {
        try {
          let newSentMessages = await getSentMessages(this.currentPage);
          this.sentMessages = [
            ...newSentMessages.messages,
            ...this.sentMessages,
          ];
          this.sortMessages();
          this.currentPage += 1;
          this.maxPages = newSentMessages.page_information.pages;
        } catch (e) {
          console.error(e);
        }
      },
      sortMessages() {
        this.sentMessages.sort(
          (curr, next) => new Date(next.created_at) - new Date(curr.created_at)
        );
      },
    },
  });

  return draftAndSentMessagesStore();
};
