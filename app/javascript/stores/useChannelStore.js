import { defineStore } from 'pinia';
import {
  getChannels,
  createChannel,
  memberJoinChannel,
  memberLeaveChannel,
} from '../api/channels/channels';

export const useChannelStore = () => {
  const channelStore = defineStore('channelStore', {
    state: () => ({
      channels: [],
    }),

    getters: {
      getChannels: state => state.channels,
    },

    actions: {
      async index() {
        try {
          this.channels = await getChannels();
          this.sortChannelsList();
        } catch (e) {
          console.error(e);
        }
      },

      async createChannel(name, description, is_private) {
        try {
          await createChannel(name, description, is_private).then(response => {
            this.channels.push(response.data);
            this.sortChannelsList();
          });
        } catch (e) {
          console.error(e);
        }
      },

      async searchChannels(query) {
        try {
          return await getChannels(query);
        } catch (e) {
          console.error(e);
        }
      },

      async joinChannel(channel_id) {
        try {
          const res = await memberJoinChannel(channel_id);
          this.channels.push(res.data.channel);
          this.sortChannelsList();
        } catch (e) {
          console.error(e);
        }
      },

      async leaveChannel(id) {
        try {
          const response = await memberLeaveChannel(id);
          this.channels = this.channels.filter(channel => channel.id != id);
          return response;
        } catch (e) {
          console.error(e);
        }
      },

      sortChannelsList() {
        this.channels = this.channels.sort((thisChannel, nextChannel) => {
          if (thisChannel.name.toLowerCase() < nextChannel.name.toLowerCase()) {
            return -1;
          }
          if (thisChannel.name.toLowerCase() > nextChannel.name.toLowerCase()) {
            return 1;
          }
          return 0;
        });
      },
    },
  });
  const store = channelStore();

  return store;
};
