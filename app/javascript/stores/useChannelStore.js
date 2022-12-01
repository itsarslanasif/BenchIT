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
        this.channels = await getChannels()
      },
    },
  });
  const store = channelStore();

  return store;
};
