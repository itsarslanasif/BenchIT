import moment from 'moment/moment';
import { defineStore } from 'pinia';
import { conversation } from '../modules/axios/editorapi'
import { useMessageStore } from './useMessagesStore'

export const useConnectionStore = () => {
  const connectionStore = defineStore('useConnectionStore', {
    state: () => ({
      isConnected: window.navigator.onLine,
      unsentQueue: [],
      sendingMessages: [],
    }),

    getters: {
      getConnectionStatus: state => state.isConnected,
    },

    actions: {
      toggleConnection(status) {
        this.isConnected = status;
        if (status) {
          this.sendAllUnsentMessages();
        }
      },
      unsendMessagesQueue(formData) {
        const date = moment()
        const message = {}
        for (const [key, value] of formData.entries()) {
          message[key] = value
        }
        message.created_at = date.format()
        this.unsentQueue.push(message);
        this.sendingMessages.push(formData)
      },
      sendAllUnsentMessages() {
        const messageStore = useMessageStore()
        this.sendingMessages.map(message => {
          conversation(message).then(res => {
            if (res.scheduled_at) {
              messageStore.addScheduleMessage(res);
            }
          });
          this.unsentQueue.shift();
        })
        this.sendingMessages = []
      },
      deleteMessage(message) {
        const indexOfMessage = this.unsentQueue.indexOf(message)
        this.unsentQueue.splice(indexOfMessage, 1);
        this.sendingMessages.splice(indexOfMessage, 1);
      }
    },
  });

  return connectionStore();
};
