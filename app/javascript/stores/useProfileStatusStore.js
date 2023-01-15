import { defineStore } from 'pinia';
import { normalizeClass } from 'vue';
import { setProfileStatus } from '../api/profiles/profileStatus';

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
    },
    setStatusApiCall(payload){
      let obj={
        "text":"afk",
        "emoji":"hello",
        "clear_after":"2023-01-06 19:41:00"
    }
       try {
        setProfileStatus(obj)
       } catch (error) {
        console.log("setStatusApicallError:",error)
       }
    }
  },
});
