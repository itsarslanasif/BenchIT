import { defineStore } from 'pinia';
import { getChannelMembers } from '../api/channels/channels';
import { errorHandler } from '../views/widgets/messageProvider';

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
    getMembers: state => state.channelMembers,
  },
  actions: {
    async getChannelMembers(query, bench_channel_id) {
      try {
        this.channelMembers = await getChannelMembers(query, bench_channel_id);
      } catch (e) {
        this.handleError(e.response.data.message);
      }
    },
    async getChannelMembersCount(bench_channel_id) {
      try {
        this.channelMembers = await getChannelMembers('', bench_channel_id);
        this.channelMemberCount = this.channelMembers.length;
      } catch (e) {
        this.handleError(e.response.data.message);
      }
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
    addMember(member) {
      const profile = this.channelMembers.find(
        channelMember => channelMember.id === member.id
      );
      if (profile == undefined) {
        this.channelMembers.push(member);
        this.channelMemberCount += 1;
      }
    },
    removeMember(member) {
      const profileIndex = this.channelMembers.findIndex(
        channelMember => channelMember.id === member.id
      );
      if (profileIndex != -1) {
        this.channelMembers.splice(profileIndex, 1);
        this.channelMemberCount -= 1;
      }
    },
    handleError(error) {
      errorHandler(error)
    }
  },
});
