import { defineStore } from 'pinia';
import {
  getChannels,
  createChannel,
  memberJoinChannel,
  memberLeaveChannel,
  getJoinedChannels,
} from '../api/channels/channels';
import { addMemberstoChannel } from '../api/members/membersApi';
import { useCurrentProfileStore } from './useCurrentProfileStore';
import { useErrorStore } from './useErrorStore';
import { useApiResponseStatusStore as apiResponseStatusStore } from './useApiResponseStatusStore';
export const useChannelStore = () => {
  const channelStore = defineStore('channelStore', {
    state: () => ({
      channels: [],
      filterChannelsValue: '',
      hideMyChannels: false,
      joinedChannels: [],
      starChannels: [],
      currentChannel: {},
      error: {},
      pageInfo: [],
      currentProfileStore: useCurrentProfileStore(),
      error: [],
    }),

    getters: {
      getChannels: state => state.channels,
      getJoinedChannels: state => state.joinedChannels,
      getStarredChannels: state => state.starChannels,
    },

    actions: {
      async index(query, sort, filter, hideMyChannels, page) {
        try {
          const newChannels = await getChannels(
            query,
            sort,
            filter,
            hideMyChannels,
            page
          );
          this.channels = [...newChannels.bench_channels];
          this.pageInfo = newChannels.page_information;
        } catch (e) {
          console.error(e);
        }
      },

      async fetchJoinedChannels() {
        try {
          this.joinedChannels = await getJoinedChannels();
          this.sortChannelsList();
          this.fetchStarredChannels();
        } catch (e) {
          this.handleError(e.response.data.message)
        }
      },

      async fetchStarredChannels() {
        this.starChannels = this.joinedChannels.filter(
          channel => channel.favourite_id != null
        );
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
          apiResponseStatusStore().setApiResponseStatus(e.response.data);
          return e.response;
        }
      },

      async joinChannel(channel_id) {
        try {
          const res = await memberJoinChannel(channel_id);
          const joinedChannel = this.channels.find(
            channel => channel.id === channel_id
          );
          this.joinedChannels.push(joinedChannel);
          this.sortChannelsList();
        } catch (e) {
          this.handleError(e.response.data.message)
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
          this.handleError(e.response.data.message)
        }
      },

      async addMembersToChannel(channelId, selectedValues) {
        try {
          let response = await addMemberstoChannel(
            channelId,
            selectedValues
          );
          return response
        } catch (e) {
          this.handleError(e.response.data.message)
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

      handleError(error) {
        useErrorStore().showError(error) 
      }
    },
  });
  const store = channelStore();

  return store;
};
