import { defineStore } from 'pinia';
import { getChannels } from '../api/channels/channels';
import { createChannel } from '../api/channels/channels';

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
        this.channels = await getChannels();
      },
      async createChannel(name, description, is_private) {
        console.log(name, description, is_private);
        await createChannel(name, description, is_private).then(response => {
          this.channels.push(response.data);
        });
      },
      leaveChannel(id) {
        this.channels = this.channels.filter(channel => channel.id != id);
      },
    },
  });
  const store = channelStore();

  return store;
};
