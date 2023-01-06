import { defineStore } from 'pinia';
import { getChannels, createChannel, memberJoinChannel, memberLeaveChannel, getJoinedChannels } from '../api/channels/channels';

export const useChannelStore = () => {
  const channelStore = defineStore('channelStore', {
    state: () => ({
      channels: [],
      joinedChannels: [],
    }),

    getters: {
      getChannels: state => state.channels,
      getJoinedChannels: state => state.joinedChannels,
    },

    actions: {
      async index() {
        try {
          this.channels = await getChannels();
          this.joinedChannels = await getJoinedChannels();
        } catch (e) {
          console.error(e);
        }
      },

      async createChannel(name, description, is_private) {
        try {
          await createChannel(name, description, is_private).then(response => {
            this.channels.push(response.data);
            this.joinedChannels.push(response.data);
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
          this.joinedChannels.push(res.data.channel);
        } catch (e) {
          console.error(e);
        }
      },

      async leaveChannel(id) {
        try {
          const response = await memberLeaveChannel(id);
          this.joinedChannels = this.joinedChannels.filter(channel => channel.id != id);
          return response
        } catch (e) {
          console.error(e)
        }
      },
    },
  });
  const store = channelStore();

  return store;
};
