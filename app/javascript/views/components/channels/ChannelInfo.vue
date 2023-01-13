<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div
        @click="OpenChannelDetailModal(true)"
        class="flex mx-3 px-1 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
      >
        <i class="fas fa-hashtag self-center fa-lg mr-1"></i>
        <p class="text-xl font-bold self-center mr-1">{{ selectedChat?.name }}</p>
        <i class="fa-solid fa-chevron-down self-center font-semibold"></i>
      </div>

      <ChannelMembersInfoVue
        :showMemberClickListener="this.OpenChannelDetailMemberModal"
        :channelId="selectedChat?.id"
        :channelName="selectedChat?.name"
      />
    </div>
  </div>
  <ChannelDetailModal
    v-if="modalOpen"
    :channelName="selectedChat?.name"
    :channelId="selectedChat?.id"
    :detailsopen="this.OpenChannelDetailModal"
    class="m-auto absolute inset-x-0"
  />
</template>

<script>
import ChannelDetailModal from '../../containers/ChannelDetailModal.vue';
import ChannelMembersInfoVue from './ChannelMembersInfo.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore';
import { storeToRefs } from 'pinia';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';

export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal, ChannelMembersInfoVue },
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    const leftPaneStore = useLeftpaneStore();
    return { ChannelDetailStore, selectedChat, leftPaneStore };},
  data() {
    return {
      modalOpen: false,
    };
  },

  methods: {
    OpenChannelDetailModal(open) {
      this.modalOpen = open;
      this.ChannelDetailStore.setSlectedOption('about');
    },
    OpenChannelDetailMemberModal(open) {
      this.ChannelDetailStore.setSlectedOption('members');
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
