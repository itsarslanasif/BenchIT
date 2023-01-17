<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div
        @click="openChannelDetailModal(true)"
        class="flex mx-3 px-1 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
      >
        <div v-if="selectedChat.is_private" class="self-center mr-1">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else class="self-center mr-1">
          <font-awesome-icon icon="fa-hashtag" />
        </div>
        <p class="text-xl font-bold self-center mr-1">
          {{ selectedChat.name }}
        </p>
        <i class="fa-solid fa-chevron-down self-center font-semibold"></i>
      </div>

      <ChannelMembersInfoVue
        v-if="selectedChat"
        :showMemberClickListener="this.OpenChannelDetailMemberModal"
        :channelId="selectedChat.id"
        :channelName="selectedChat.name"
      />
    </div>
  </div>
  <ChannelDetailModal
    v-if="modalOpen && selectedChat"
    :detailsopen="openChannelDetailModal"
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
    return { ChannelDetailStore, selectedChat, leftPaneStore };
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
