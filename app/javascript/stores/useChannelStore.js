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
      starChannels: [],
      currentChannel: {},
    }),

    getters: {
      getChannels: state => state.channels,
      getJoinedChannels: state => state.joinedChannels,
      getStarredChannels: state => state.starChannels
    },

    actions: {
      async index() {
        try {
          this.channels = await getChannels();
          this.joinedChannels = await getJoinedChannels();
          this.starChannels = this.joinedChannels.filter(function (el) { return el.favourite_id !== null });
          this.joinedChannels = this.joinedChannels.filter(function (el) { return el.favourite_id === null })
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
          this.starChannels = this.starChannels.filter(
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

      addJoinChannel(channel) {
        const index = this.joinedChannels.indexOf(channel);
        if (index === -1) {
          this.joinedChannels.push(channel);
        }
      },

      removeJoinChannel(channel) {
        const index = this.joinedChannels.indexOf(channel);
        if (index > -1) {
          this.joinedChannels.splice(index, 1);
        }
      },

      setCurrentChannel(channel) {
        this.currentChannel = channel;
      },

      removeStarredChannel(channel) {
        const index = this.starChannels.indexOf(channel);
        if (index > -1) {
          this.starChannels.splice(index, 1);
        }
      },

      addStarredChannel(channel) {
        const index = this.starChannels.indexOf(channel);
        if (index === -1) {
          this.starChannels.push(channel);
        }
      },

    },
  });
  const store = channelStore();

  return store;
};
