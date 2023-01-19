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
        messageToEdit: null,
      };
    },

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
      getMessage(id) {
        return this.messages.find(message => message.id === id);
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
      updateMessage(data){

        if (data.parent_message_id) {
          const message = this.messages.find(element => element.id === data.parent_message_id);
          const findThreadMessageIndex = message.replies.findIndex(
            element => element.id === data.id
          );

          if (findThreadMessageIndex != -1) {
            message.replies[findThreadMessageIndex] = data;
          }
        } else {
          const findMessageIndex = this.messages.findIndex(element => element.id === data.id);

          if (findMessageIndex != -1){
            let messsageToUpdate={...data}
            messsageToUpdate.replies=this.messages[findMessageIndex].replies
            this.messages[findMessageIndex]=messsageToUpdate
          }
        }
      }
    },
  });

  return messageStore();
};
