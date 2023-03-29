<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div class="flex px-1 my-2 items-center rounded cursor-pointer">
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
        <div
          v-if="selectedChat.topic"
          class="flex items-center gap-1 hover-trigger"
          @click="toggleEdittopic"
        >
          <p class="text-black-500">{{ selectedChat.topic }}</p>
          <p class="text-info hover-target">Edit</p>
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
  <edit-topic-modal
    v-if="topicModal"
    :chat="selectedChat"
    :closeModal="toggleEdittopic"
  />
</template>

<script>
import ChatDetailModal from '../../containers/ChatDetailModal.vue';
import GroupMembersInfoVue from './GroupMembersInfo.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import editTopicModal from '../channeldetail/editTopicModal.vue';
export default {
  name: 'ChannelInfo',
  components: { ChatDetailModal, GroupMembersInfoVue, editTopicModal },
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
      topicModal: false,
    };
  },
  methods: {
    toggleShowModal() {
      if (!this.modalOpen) {
        this.ChannelDetailStore.setSelectedOption('about');
        this.currentGroup = this.selectedChat;
      }
      this.modalOpen = !this.modalOpen;
    },
    openChannelDetailMemberModal(open) {
      this.ChannelDetailStore.setSelectedOption('members');
      this.modalOpen = open;
    },
    toggleEdittopic() {
      this.topicModal = !this.topicModal;
    },
  },
};
</script>
<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
.hover-trigger .hover-target {
  display: none;
}

.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
