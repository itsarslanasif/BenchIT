<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div
        @click="OpenChannelDetailModal(true)"
        class="flex px-1 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
      >
        <i class="fas fa-hashtag self-center fa-lg mr-1"></i>
        <p class="text-xl font-bold self-center mr-1">{{ channel.name }}</p>
        <i class="fa-solid fa-chevron-down self-center fa-xs"></i>
      </div>
      <ChannelMembersInfoVue
        :showMemberClickListener="this.OpenChannelDetailMemberModal"
        :channelId="channel.id"
      />
    </div>
  </div>
  <ChannelDetailModal
    v-if="modalOpen"
    :channelName="channel.name"
    :channelId="channel.id"
    :detailsopen="this.OpenChannelDetailModal"
    class="m-auto absolute inset-x-0"
  />
</template>

<script>
import ChannelDetailModal from '../../containers/ChannelDetailModal.vue';
import ChannelMembersInfoVue from './ChannelMembersInfo.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore';

export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal, ChannelMembersInfoVue },
  props: ['channel'],
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    return { ChannelDetailStore };
  },
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
