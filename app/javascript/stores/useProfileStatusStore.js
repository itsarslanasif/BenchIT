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
      console.log("closeing                k")
    },
    // setStatusApiCall(currentWorkspaceId,currentProfileId,payload){
    //   let obj={
    //     "text_status":payload.text,
    //     "emoji_status":payload.emoji,
    //     "clear_status_after":"2023-01-06 19:41:00"
    // }
    //    try {
    //     setProfileStatus(currentWorkspaceId,currentProfileId,obj).then(
    //       (response) => {
    //           console.log("response",response.profile)
    //           currentProfile.setProfile(response.profile)
    //       },)
    //    } catch (error) {
    //     console.log("setStatusApicallError:",error)
    //    }
    // }
  },
});
