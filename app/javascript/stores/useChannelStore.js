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
      currentPage: 1,
      pageInfo: []
    }),

    getters: {
      getChannels: state => state.channels,
      getJoinedChannels: state => state.joinedChannels,
      getStarredChannels: state => state.starChannels,
    },

    actions: {
      async index() {
        try {
          let newChannels = await getChannels();
          this.channels = [...this.channels, ...newChannels.bench_channels]
          this.pageInfo = newChannels.page_information
          this.joinedChannels = await getJoinedChannels();
          this.starChannels = this.joinedChannels.filter(
            channel => channel.favourite_id !== null
          );
          this.joinedChannels = this.joinedChannels.filter(
            channel => channel.favourite_id === null
          );
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

      async searchChannels(query, sort) {
        try {
          let newChannels = await getChannels(query, sort, this.currentPage);
          this.channels = [...newChannels.bench_channels];
        } catch (e) {
          console.error(e);
        }
      },

      async joinChannel(channel_id) {
        try {
          const res = await memberJoinChannel(channel_id);
          const joinedChannel = this.channels.find((channel) => channel.id === channel_id)
          this.joinedChannels.push(joinedChannel);
          this.sortChannelsList();
        } catch (e) {
          console.error(e);
        }
      },

      async leaveChannel(id) {
        try {
          const response = await memberLeaveChannel(id);
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

      addChannelJoined(channel) {
        const channel_item = this.channels.find(
          element => element.id === channel.id
        );
        const joinedChannel = this.joinedChannels.find(
          element => element.id === channel.id
        );

        if (channel_item == undefined) this.channels.push(channel);
        if (joinedChannel == undefined) this.joinedChannels.push(channel);
      },

      removeChannelJoined(channel) {
        const joinedChannelIndex = this.joinedChannels.findIndex(
          element => element.id === channel.id
        );

        if (joinedChannelIndex != -1) {
          this.joinedChannels.splice(joinedChannelIndex, 1);
        }
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
