import { defineStore } from 'pinia';
import {
  getChannels,
  createChannel,
  memberJoinChannel,
  memberLeaveChannel,
  getJoinedChannels,
} from '../api/channels/channels';
import { useApiResponseStatusStore as apiResponseStatusStore } from './useApiResponseStatusStore';
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
          let newChannels = await getChannels();
          this.channels = [...newChannels]
          this.joinedChannels = await getJoinedChannels();
          this.sortChannelsList();
        } catch (e) {
          console.error(e);
        }
      },

      async createChannel(name, description, is_private) {
        try {
          await createChannel(name, description, is_private).then(response => {

            if (response?.data?.errors) {
              apiResponseStatusStore().setApiResponseStatus(response.data);
              return response.data;
            } else {
              apiResponseStatusStore().setApiResponseStatus(response);
              this.channels.push(response.data);
              this.joinedChannels.push(response.data);
              this.sortChannelsList();
              return response.data;
            }
          });
        } catch (e) {
          console.error(e);
        }
      },

      async searchChannels(query) {
        try {
          this.channels = await getChannels(query);
          
        } catch (e) {
          console.error(e);
        }
      },

      async joinChannel(channel_id) {
        try {
          const res = await memberJoinChannel(channel_id);
          this.joinedChannels.push(res.data.channel);
          this.sortChannelsList();
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
          console.error(e);
        }
      },

      sortChannelsList() {
        this.joinedChannels = this.joinedChannels.sort(
          (thisChannel, nextChannel) => {
            if (
              thisChannel.name.toLowerCase() < nextChannel.name.toLowerCase()
            ) {
              return -1;
            }

            if (
              thisChannel.name.toLowerCase() > nextChannel.name.toLowerCase()
            ) {
              return 1;
            }
            return 0;
          }
        );
      },
    },
  });
  const store = channelStore();

  return store;
};
