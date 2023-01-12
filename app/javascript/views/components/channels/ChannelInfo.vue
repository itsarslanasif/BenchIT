<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div>
        <div class="flex mx-3 px-1 my-2 gap-2">
          <div
            v-if="!leftPaneStore.getLeftpaneFlag"
            @click="leftPaneStore.openLeftPane"
            class="text-2xl px-3 mt-1 hover:bg-slate-50 rounded cursor-pointer"
          >
            <font-awesome-icon icon="fa-regular fa-rectangle-list" />
          </div>
          <div
            @click="OpenChannelDetailModal(true)"
            class="flex overflow-x-hidden text-ellipsis px-3 hover:bg-slate-50 rounded cursor-pointer"
          >
            <i class="fas fa-hashtag self-center fa-lg mr-1"></i>
            <p class="text-xl font-bold self-center mr-1">{{ channel.name }}</p>
            <i class="fa-solid fa-chevron-down self-center fa-xs"></i>
          </div>
        </div>
      </div>

      <ChannelMembersInfoVue
        :showMemberClickListener="this.OpenChannelDetailMemberModal"
        :channelId="channel.id"
        :channelName="channel.name"
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
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';

export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal, ChannelMembersInfoVue },
  props: ['channel'],
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    const leftPaneStore = useLeftpaneStore();
    return { ChannelDetailStore, leftPaneStore };
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
