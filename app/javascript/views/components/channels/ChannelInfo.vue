<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div>
        <div class="flex mx-3 px-1 my-2 gap-2">
          <div v-if="!leftPaneStore.getLeftpaneFlag" @click="leftPaneStore.openLeftPane"
            class="text-2xl px-3 mt-1 hover:bg-slate-50 rounded cursor-pointer">
            <font-awesome-icon icon="fa-regular fa-rectangle-list" />
          </div>
          <div @click="openChannelDetailModal(true)"
            class="flex overflow-x-hidden text-ellipsis px-3 hover:bg-slate-50 rounded cursor-pointer">
            <i class="fas fa-hashtag self-center fa-lg mr-1"></i>
            <p class="text-xl font-bold self-center mr-1">{{ channel.name }}</p>
            <i class="fa-solid fa-chevron-down self-center fa-xs"></i>
          </div>
        </div>
      </div>

      <ChannelMembersInfoVue :showMemberClickListener="this.openChannelDetailMemberModal" :channelId="channel.id"
        :channelName="channel.name" />
    </div>
  </div>
  <ChannelDetailModal v-if="modalOpen" :currentChannel="this.currentChannel" :detailsopen="this.openChannelDetailModal"
    class="m-auto absolute inset-x-0" />
</template>

<script>
import ChannelDetailModal from '../../containers/ChannelDetailModal.vue';
import ChannelMembersInfoVue from './ChannelMembersInfo.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';

export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal, ChannelMembersInfoVue },
  props: ['channel'],
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    const leftPaneStore = useLeftpaneStore();
    return { ChannelDetailStore, joinedChannels, channelStore, leftPaneStore };
  },
  data() {
    return {
      modalOpen: false,
      currentChannel: {},
    };
  },

  methods: {
    openChannelDetailModal(open) {
      this.modalOpen = open;
      this.ChannelDetailStore.setSlectedOption('about');
      this.getCurrentChannel();
      this.channelStore.setCurrentChannel(this.currentChannel);
    },
    openChannelDetailMemberModal(open) {
      this.ChannelDetailStore.setSlectedOption('members');
      this.modalOpen = open;
    },
    getCurrentChannel() {
      this.currentChannel = this.channelStore.joinedChannels.find(obj => obj.id === Number(this.channel.id)) ||
        this.channelStore.starChannels.find(obj => obj.id === Number(this.channel.id));
    }
  },
};
</script>
<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
</style>
