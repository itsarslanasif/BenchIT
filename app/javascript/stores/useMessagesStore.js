import { defineStore } from 'pinia';
import { getMessageHistory } from '../modules/socket/messageHistory';
import { deleteMessage } from '../api/messages';
import { CONSTANTS } from '../assets/constants';
import { getUserProfile } from '../api/profiles/userProfile';
import { getChannel } from '../api/channels/channels';
import { decryption } from '../modules/crypto/crypto';
import { getScheduleMessages } from '../api/scheduleMessages';

export const useMessageStore = () => {
  const messageStore = defineStore('messages', {
    state: () => ({
      messages: [],
      currMessage: [],
      scheduleMessage: [],
      currentPage: 1,
      maxPages: null,
      hasMoreMessages: true,
      selectedChat: {},
      newMessageSent: false,
        messageToEdit: null,
    }),

    getters: {
      getMessages: state => state.messages,
      getMessageToEdit: state => state.messageToEdit,
      repliesCount: state => {
        if (
          !CONSTANTS.NULL_VALUES.includes(state.messages) &&
          state.currMessage !== null
        ) {
          state.messages.find(m => m.id == state.currMessage.id).replies.length;
        }
      },
      getSelectedChat: state => state.selectedChat
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
          console.error(e);
        }
        if (conversation_type === 'profiles') {
          const currentWorkspace = decryption(sessionStorage, 'currentWorkspace')
          this.selectedChat = await getUserProfile(
            currentWorkspace.id,
            id
          );
        } else if (conversation_type === 'channels') {
          this.selectedChat = await getChannel(id);
        }
      },
      async addMessage(msg) {
        messageStore;
        this.messages.push(msg);
      },
      async deleteMessage(id) {
        await deleteMessage(id);
      },
      getMessage(id) {
        return this.messages.find(message => message.id === id);
      },
      addScheduleMessage(payload) {
        this.scheduleMessage.push(payload)
      },
      async getAllScheduleMessages() {
        this.scheduleMessage = await getScheduleMessages()
      },
      setMessageToEdit(message) {
        this.messageToEdit = message;
      },
      removeMessageToEdit() {
        this.messageToEdit = null;
      },
      isMessageToEdit(message) {
        if (this.messageToEdit)
          return this.messageToEdit && (message.id == this.messageToEdit.id)
        return false
      },
    },
  });

  return messageStore();
};
