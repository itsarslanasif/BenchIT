import { defineStore } from 'pinia';
import { getMessageHistory } from '../modules/socket/messageHistory';
import { deleteMessage } from '../api/messages';
import { CONSTANTS } from '../assets/constants';
import { getUserProfile } from '../api/profiles/userProfile';
import { getChannel } from '../api/channels/channels';

export const useMessageStore = () => {
  const messageStore = defineStore('messages', {
    state: () => {
      return {
        selectedChat: {},
        messages: [],
        currMessage: null,
      };
    },

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
        this.messages = await getMessageHistory(
          conversation_type.slice(0, -1),
          id
        );
        if (conversation_type === 'profiles') {
          this.selectedChat = await getUserProfile(
            JSON.parse(sessionStorage.getItem('currentWorkspace')).id,
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
    },
  });

  return messageStore();
};
