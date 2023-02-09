<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div class="flex px-1 my-2 mx-2 hover:bg-slate-50 rounded cursor-pointer">
        <div v-if="selectedChat.is_private" class="self-center mr-1">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else class="self-center mr-1">
          <font-awesome-icon icon="fa-hashtag" />
        </div>
        <div
          @click="openChannelDetailModal(true)"
          class="flex overflow-x-hidden text-ellipsis"
        >
          <p class="text-xl font-bold self-center mr-1">
            {{ selectedChat.name }}
          </p>
          <i class="fa-solid fa-chevron-down self-center fa-xs"></i>
        </div>
      </div>
      <div
        @click="rightPaneStore.toggleChatShow(false)"
        class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer"
      >
        <i class="fas fa-xmark self-center fa-lg"></i>
      </div>
    </div>
  </div>
  <ChannelDetailModal
    v-if="modalOpen"
    :selectedChat="this.currentChannel"
    :detailsopen="this.openChannelDetailModal"
    class="m-auto absolute inset-x-0"
  />
</template>

<script>
import ChannelDetailModal from '../../../containers/ChannelDetailModal.vue';
import ChannelMembersInfoVue from '../../channels/ChannelMembersInfo.vue';
import { useChannelDetailStore } from '../../../../stores/useChannelDetailStore';
import { useChannelStore } from '../../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useRightpaneMessageStore } from '../../../../stores/useRightpaneMessageStore';
import { useRightPaneStore } from '../../../../stores/useRightPaneStore';

export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal, ChannelMembersInfoVue },
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    const messagesStore = useRightpaneMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    const rightPaneStore = useRightPaneStore();
    return {
      ChannelDetailStore,
      joinedChannels,
      channelStore,
      selectedChat,
      messagesStore,
      rightPaneStore,
    };
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
      this.currentChannel =
        this.channelStore.joinedChannels.find(
          obj => obj.id === Number(this.selectedChat.id)
        ) ||
        this.channelStore.starChannels.find(
          obj => obj.id === Number(this.selectedChat.id)
        );
    },
  },
};
</script>
<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
</style>
