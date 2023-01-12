<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div
        @click="OpenChannelDetailModal(true)"
        class="flex mx-3 px-1 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
      >
        <i v-if="conversationInfo.is_private" class="fas fa-lock self-center fa-lg mr-1"></i>
        <i v-else  class="fas fa-hashtag self-center fa-lg mr-1"></i>
        <p class="text-xl font-bold self-center mr-1">{{ conversationInfo.name }}</p>
        <i class="fa-solid fa-chevron-down self-center fa-xs"></i>
      </div>
      <ChannelMembersInfoVue
        :showMemberClickListener="this.OpenChannelDetailMemberModal"
      />
    </div>
  </div>
  <ChannelDetailModal
    v-if="modalOpen"
    :detailsOpen="this.OpenChannelDetailModal"
    class="m-auto absolute inset-x-0"
  />
</template>

<script>
import ChannelDetailModal from '../../containers/ChannelDetailModal.vue';
import ChannelMembersInfoVue from './ChannelMembersInfo.vue';
import { useConversationInfoStore } from '../../../stores/useConversationInfoStore';
import { storeToRefs } from 'pinia';
import { CONSTANTS } from '../../../assets/constants';
export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal, ChannelMembersInfoVue },
  setup() {
    const conversationInfoStore = useConversationInfoStore();
    const { conversationInfo } = storeToRefs(conversationInfoStore);
    return { conversationInfo, conversationInfoStore };
  },
  data() {
    return {
      modalOpen: false,
    };
  },

  methods: {
    OpenChannelDetailModal(open) {
      this.modalOpen = open;
      this.conversationInfoStore.setSlectedOption(CONSTANTS.ABOUT);
    },
    OpenChannelDetailMemberModal(open) {
      this.conversationInfoStore.setSlectedOption(CONSTANTS.MEMBERS);
      this.modalOpen = open;
    },
  },
};
</script>
<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
</style>
