import { defineStore } from 'pinia';
import { getSentMessages } from '../api/recentlySent/recentlySentMessages';
import { errorHandler } from '../views/widgets/messageProvider';

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
      loadDraftMessages() {},
      async loadSentMessages() {
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
          errorHandler(e.response.data.message);
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
