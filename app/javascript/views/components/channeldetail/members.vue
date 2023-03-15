<template>
  <div class="bg-white flex flex-col p-5 gap-3">
    <div class="py-5">
      <input
        class="searchbar shadow bg-neutral-900 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        type="text"
        v-model="query"
        :placeholder="$t('channel_details.find_members')"
        @keyup="searchQuery()"
      />
    </div>
    <div
      v-if="channelDetailStore.channelMembers.length > 0"
      class="maxHeight overflow-auto"
    >
      <div v-for="member in channelDetailStore.channelMembers" :key="member.id">
        <MemberCard @click="showUserProfile(member.id)" :member="member" />
      </div>
    </div>
    <p v-if="channelDetailStore.channelMembers.length == 0">
      {{ $t('channel_details.no_matches_found') }} " {{ query }} "
    </p>
  </div>
</template>

<script>
import MemberCard from '../../widgets/memberCard.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore.js';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { errorHandler } from '../../widgets/messageProvider';
export default {
  components: { MemberCard },
  props: { toggleModal: Function },
  query: '',
  mounted() {
    this.searchQuery();
  },
  setup() {
    const channelDetailStore = useChannelDetailStore();
    const rightPaneStore = useRightPaneStore();
    const profilesStore = useProfileStore();
    const userProfileStore = useUserProfileStore();
    return {
      channelDetailStore,
      rightPaneStore,
      profilesStore,
      userProfileStore,
    };
  },
  methods: {
    async searchQuery() {
      let channel_id = window.location.pathname.split('/')[2];
      try {
        await this.channelDetailStore.getChannelMembers(this.query, channel_id);
      } catch (e) {
        errorHandler(e.response.data.message);
      }
    },
    showUserProfile(profile_id) {
      this.setUserProfileForPane(profile_id);
      this.rightPaneStore.toggleUserProfileShow(true);
    },

    setUserProfileForPane(profile_id) {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === profile_id
      );
      this.userProfileStore.setUserProfile(profile);
      this.toggleModal();
    },
  },
};
</script>
<style scoped>
.maxHeight {
  max-height: 400px;
}
</style>
