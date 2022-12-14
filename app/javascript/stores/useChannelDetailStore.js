import { defineStore } from 'pinia';
import { getChannelMembers } from '../api/channels/channels';
import { getChannelMemberCount } from '../api/channels/channels';

export const useChannelDetailStore = defineStore('channelDetailStore ', {
  state: () => ({
    selectedOption:"about",
    channelMembers:[],
  }),

  getters: {
    getSelectedOption() {
      return this.selectedOption;
    },
  },
  actions: {
    async getChannelMembers(query,bench_channel_id) {
      this.channelMembers = await getChannelMembers(query,bench_channel_id)
      console.log(this.channelMembers)
    },
    async getChannelMembersCount(bench_channel_id) {
      return await getChannelMemberCount(bench_channel_id)
    },
    setSlectedOption(option) {
      this.selectedOption=option;
    },
    isAbout() {
      return this.selectedOption=="about";
    },
    isMembers() {
      return this.selectedOption=='members';
    },
    isIntegrations() {
      return this.selectedOption=='integrations';
    },
    isSettings() {
      return this.selectedOption=='settings';
    },
  },
});
