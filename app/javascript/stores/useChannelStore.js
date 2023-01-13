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
          this.channels = await getChannels();
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
          return await getChannels(query);
        } catch (e) {
          console.error(e);
        }
      },

      async joinChannel(channel_id) {
        try {
          const res = await memberJoinChannel(channel_id);
          this.channels.push(res.data.channel);
          this.joinedChannels.push(res.data.channel);
          this.sortChannelsList();
        } catch (e) {
          console.error(e);
        }
      },

      async leaveChannel(id) {
        try {
          const response = await memberLeaveChannel(id);
          this.channels = this.channels.filter(channel => channel.id != id);
          this.joinedChannels = this.joinedChannels.filter(
            channel => channel.id != id
          );
          return response;
          this.joinedChannels = this.joinedChannels.filter(
            channel => channel.id != id
          );
          return response;
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

      addChannelJoined(channel) {
        const channel_item = this.channels.find(
          element => element.id === channel.id
        );
        const joinedChannel = this.joinedChannels.find(
          element => element.id === channel.id
        );

        if (channel_item != undefined) {
          if (joinedChannel == undefined) this.joinedChannels.push(channel);
        } else {
          if (joinedChannel == undefined) {
            this.channels.push(channel);
            this.joinedChannels.push(channel);
          }
        }
      },

      removeChannelJoined(channel) {
        const joinedChannelIndex = this.joinedChannels.findIndex(
          element => element.id === channel.id
        );

        if (joinedChannelIndex != -1) {
          this.joinedChannels.splice(joinedChannelIndex, 1);
        }
      },
    },
  });
  const store = channelStore();

  return store;
};
