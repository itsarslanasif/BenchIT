import { defineStore } from 'pinia';
import { getMessageHistory } from '../modules/socket/messageHistory';
import { deleteMessage } from '../api/messages';
import { CONSTANTS } from '../assets/constants';
import { getUserProfile } from '../api/profiles/userProfile';
import { getChannel } from '../api/channels/channels';
import { decryption } from '../modules/crypto/crypto';

export const useMessageStore = () => {
  const messageStore = defineStore('messages', {
    state: () => ({
      messages: [],
      currMessage: [],
      currentPage: 1,
      maxPages: null,
      hasMoreMessages: true,
      selectedChat: {},
      newMessageSent: false,
      error: {},
    }),

    getters: {
      getMessages: state => state.messages,
      repliesCount: state => {
        if (
          !CONSTANTS.NULL_VALUES.includes(state.messages) &&
          state.currMessage !== null
        ) {
          state.messages.find(m => m.id == state.currMessage.id).replies.length;
        }
      },
    },
    actions: {
      setSelectedChat(selectedChat) {
        this.selectedChat = selectedChat;
      },
      async index(conversation_type, id) {
        try {
          let newMessages = await getMessageHistory(
            conversation_type.slice(0, -1),
            id,
            this.currentPage
          );
          this.messages = [...newMessages.messages, ...this.messages];
          this.currentPage += 1;
          this.maxPages = newMessages.page_information.pages;
          this.hasMoreMessages = this.currentPage > this.maxPages;
        } catch (e) {
          this.handleError(error)
        }
        if (conversation_type === 'profiles') {
          const currentWorkspace = decryption(sessionStorage, 'currentWorkspace')
          try {
          this.selectedChat = await getUserProfile(
            currentWorkspace.id,
            id
          );
          } catch (error) {
            this.handleError(error)
          }
        } else if (conversation_type === 'channels') {
          try {
          this.selectedChat = await getChannel(id);
          } catch (error) {
            this.handleError(error)
          }
        }
      },
      async addMessage(msg) {
        messageStore;
        this.messages.push(msg);
      },
      async deleteMessage(id) {
        try {
        await deleteMessage(id);
        } catch (error) {
          this.handleError(error)
        }
      },
      getMessage(id) {
        return this.messages.find(message => message.id === id);
      },
      handleError (error) {
        this.error = error
      }
    },
  });

  return messageStore();
};
