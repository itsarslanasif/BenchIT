import { defineStore } from 'pinia';
import {
  getChannels,
  createChannel,
  memberJoinChannel,
  memberLeaveChannel,
  getJoinedChannels,
} from '../api/channels/channels';
import { useCurrentProfileStore } from './useCurrentProfileStore';
import { useApiResponseStatusStore as apiResponseStatusStore } from './useApiResponseStatusStore';
export const useChannelStore = () => {
  const channelStore = defineStore('channelStore', {
    state: () => ({
      channels: [],
      joinedChannels: [],
      starChannels: [],
      currentChannel: {},
      pageInfo: [],
      currentProfileStore : useCurrentProfileStore()
    }),

    getters: {
      getChannels: state => state.channels,
      getJoinedChannels: state => state.joinedChannels,
      getStarredChannels: state => state.starChannels,
    },

    actions: {
      async index(query, sort, page) {
        try {
          let newChannels = await getChannels(query, sort, page);
          this.channels = [...newChannels.bench_channels]
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
          const result = await createChannel(name, description, is_private);
          apiResponseStatusStore().setApiResponseStatus(result.data);
          this.channels.push(result.data);
          this.joinedChannels.push(result.data);
          this.sortChannelsList();
          return result;
        } catch (e) {
          return e.response;
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
          let foundIndex = this.channels.findIndex(channel => channel.id == id);
          this.channels[foundIndex].profiles = this.channels[
            foundIndex
          ].profiles.filter(profile => {
            profile.id === this.currentProfileStore.currentProfile.id;
          });
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
