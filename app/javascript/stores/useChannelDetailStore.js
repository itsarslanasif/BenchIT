import { defineStore } from 'pinia';
import { getChannels } from '../api/channels/channels';

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
    async getchannelMembers(query,bench_channel_id) {
      this.channelMembers = await getChannels()
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
