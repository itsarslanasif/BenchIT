<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div class="">
        <div
          class="flex px-1 my-2 mx-2 hover:bg-slate-50 rounded cursor-pointer"
        >
          <div
            @click="toggleShowModal"
            class="flex overflow-x-hidden text-ellipsis"
          >
            <p class="text-xl font-bold self-center mr-1">
              {{ selectedChat.name }}
            </p>
            <i class="fa-solid fa-chevron-down self-center fa-xs"></i>
          </div>
        </div>
      </div>
      <GroupMembersInfoVue />
    </div>
  </div>
</template>

<script>
import ChatDetailModal from '../../containers/ChatDetailModal.vue';
import GroupMembersInfoVue from './GroupMembersInfo.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';

export default {
  name: 'ChannelInfo',
  components: { ChatDetailModal, GroupMembersInfoVue },
  setup() {
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { joinedChannels, channelStore, selectedChat };
  },
  data() {
    return {
      modalOpen: false,
      currentChannel: {},
    };
  },
  methods: {
    toggleShowModal() {
      if (!this.modalOpen) {
        this.ChannelDetailStore.setSlectedOption('about');
        this.getCurrentChannel();
        this.channelStore.setCurrentChannel(this.currentChannel);
      }
      this.modalOpen = !this.modalOpen;
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
