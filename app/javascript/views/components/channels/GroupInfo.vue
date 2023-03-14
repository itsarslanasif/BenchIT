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
      <GroupMembersInfoVue @click="toggleShowModal" />
    </div>
  </div>
  <ChatDetailModal
    v-if="modalOpen"
    :chat="this.currentGroup"
    :toggleModal="toggleShowModal"
    class="m-auto absolute inset-x-0"
  />
</template>

<script>
import ChatDetailModal from '../../containers/ChatDetailModal.vue';
import GroupMembersInfoVue from './groupMembersInfo.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore';
import { useMessageStore } from '../../../stores/useMessagesStore';

export default {
  name: 'ChannelInfo',
  components: { ChatDetailModal, GroupMembersInfoVue },
  setup() {
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    const ChannelDetailStore = useChannelDetailStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { joinedChannels, ChannelDetailStore, channelStore, selectedChat };
  },
  data() {
    return {
      modalOpen: false,
      currentGroup: {},
    };
  },
  methods: {
    toggleShowModal() {
      if (!this.modalOpen) {
        this.ChannelDetailStore.setSlectedOption('about');
        this.currentGroup = this.selectedChat;
      }
      this.modalOpen = !this.modalOpen;
    },
    openChannelDetailMemberModal(open) {
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
