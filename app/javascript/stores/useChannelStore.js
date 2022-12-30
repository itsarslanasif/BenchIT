import { defineStore } from 'pinia';
import { getChannels } from '../api/channels/channels';

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
        this.channels = await getChannels()
        } catch(e) {
          console.error(e)
        }
      },
      leaveChannel(id) {
        this.channels = this.channels.filter((channel) => channel.id != id)
      }
    },
  });
  const store = channelStore();

  return store;
};
