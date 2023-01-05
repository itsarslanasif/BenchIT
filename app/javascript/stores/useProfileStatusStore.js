import { defineStore } from 'pinia';
import { normalizeClass } from 'vue';

export const useProfileStatusStore = defineStore('ProfileStatusStore', {
  state: () => ({
    showProfileStatusPopUp: false,
    showProfileStatusPopUpSubModel:false,
  }),
  actions: {
    async getChannelMembers(query, bench_channel_id) {
      this.channelMembers = await getChannelMembers(query, bench_channel_id);
    },
    toggleProfileStatusPopUp() {
      this.showProfileStatusPopUp = !this.showProfileStatusPopUp;
    }
  },
});
