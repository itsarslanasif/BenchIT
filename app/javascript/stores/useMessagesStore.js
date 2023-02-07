import { defineStore } from 'pinia';
import { getMessageHistory } from '../modules/socket/messageHistory';
import { deleteMessage } from '../api/messages';
import { CONSTANTS } from '../assets/constants';
import { getUserProfile } from '../api/profiles/userProfile';
import { getChannel } from '../api/channels/channels';
import { decryption } from '../modules/crypto/crypto';
import {
  getScheduleMessages,
  sendScheduledMessageNow,
  deleteScheduledMessage,
  editScheduledContent,
  reScheduleTime,
} from '../api/scheduleMessages';

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
      messageToEdit: {
        content: null,
        isScheduled: false,
        scheduledId: null,
      },
      error: {},
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
      getSelectedChat: state => state.selectedChat,
    },
    actions: {
      setSelectedChat(selectedChat) {
        this.selectedChat = selectedChat;
      },
      deleteChannelName() {
        delete this.selectedChat.name;
      },
      setSelectedChatUserName(userName) {
        this.selectedChat = { ...this.selectedChat, username: userName };
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
          const currentWorkspace = decryption(
            sessionStorage,
            'currentWorkspace'
          );
          try {
          this.selectedChat = await getUserProfile(currentWorkspace.id, id);
          this.selectedChat.conversation_type = 'Profile';
          } catch (error) {
            this.handleError(error)
          }
        } else if (conversation_type === 'channels') {
          try {
          this.selectedChat = await getChannel(id);
          this.selectedChat.conversation_type = 'Channel';
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
      addScheduleMessage(payload) {
        this.scheduleMessage.push(payload);
      },
      async getAllScheduleMessages() {
        this.scheduleMessage = await getScheduleMessages();
      },
      setMessageToEdit(message) {
        this.messageToEdit.content = message;
      },
      removeMessageToEdit() {
        this.messageToEdit.content = null;
      },
      isMessageToEdit(message) {
        if (this.messageToEdit.content)
          return (
            this.messageToEdit.content &&
            message.id == this.messageToEdit.content.id
          );
        return false;
      },
      sendMessageNow(scheduledMessage) {
        sendScheduledMessageNow(scheduledMessage.id).then(res => {
          this.alterScheduledMessages(res, scheduledMessage.id);
        });
      },
      deleteScheduledMessage(scheduledMessage) {
        deleteScheduledMessage(scheduledMessage.id).then(res => {
          this.alterScheduledMessages(res, scheduledMessage.id);
        });
      },
      alterScheduledMessages(res, id) {
        if (res.success) {
          this.scheduleMessage = this.scheduleMessage.filter(
            message => message.id != id
          );
        }
      },
      setEditSchedule(message) {
        this.messageToEdit = {
          content: message.content,
          scheduledId: message.id,
          isScheduled: true,
        };
      },
      reEditScheduledMessage(payload) {
        editScheduledContent(payload);
        this.messageToEdit = {
          content: null,
          scheduledId: null,
          isScheduled: false,
        };
      },
      reScheduleMessage(payload) {
        reScheduleTime(payload).then(() => {
          const scheduledMessage = this.scheduleMessage.find(
            message => message.id === payload.id
          );
          scheduledMessage.scheduled_at = payload.scheduled_at;
        });
      },
      handleError (error) {
        this.error = error
      }
    },
  });

  return messageStore();
};
