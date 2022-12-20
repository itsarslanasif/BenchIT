import { defineStore } from 'pinia';
import { getChannelMembers } from '../api/channels/channels';

export const useChannelDetailStore = defineStore('channelDetailStore ', {
  state: () => ({
    selectedOption: 'about',
    channelMemberCount: 0,
    channelMembers: [],
  }),
  getters: {
    getSelectedOption() {
      return this.selectedOption;
    },
  },
  actions: {
    async getChannelMembers(query, bench_channel_id) {
      this.channelMembers = await getChannelMembers(query, bench_channel_id);
    },
    async getChannelMembersCount(bench_channel_id) {
      let members = await getChannelMembers('', bench_channel_id);
      this.channelMemberCount = members.length;
      return this.channelMemberCount;
    },
    setSlectedOption(option) {
      this.selectedOption = option;
    },
    isAbout() {
      return this.selectedOption == 'about';
    },
    isMembers() {
      return this.selectedOption == 'members';
    },
    isIntegrations() {
      return this.selectedOption == 'integrations';
    },
    isSettings() {
      return this.selectedOption == 'settings';
    },
  },
});