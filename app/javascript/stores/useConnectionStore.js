import moment from 'moment/moment';
import { defineStore } from 'pinia';
import { conversation } from '../modules/axios/editorapi'

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
        const message = formData.entries().reduce((message, [key, value]) => {
          message[key] = value;
          return message;
        }, {});
        message.created_at = date.format()
        this.unsentQueue.push(message);
        this.sendingMessages.push(formData)
      },
      sendAllUnsentMessages() {
        this.sendingMessages.map(message => {
          conversation(message).then(res => {
            if (res.scheduled_at) {
              this.addScheduleMessage(res);
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
