<template>
  <div class="relative">
    <div
      class="border-b border-light px-1 h-12 items-center flex justify-between"
    >
      <div class="flex px-1 my-2 items-center gap-1 cursor-pointer">
        <div
          class="flex px-1 my-2 mx-2 hover:bg-slate-50 rounded cursor-pointer"
        >
          <div v-if="selectedChat.is_private" class="self-center mr-1">
            <font-awesome-icon icon="fa-lock" />
          </div>
          <div v-else class="self-center mr-1">
            <font-awesome-icon icon="fa-hashtag" />
          </div>
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
          @click="toggleEditTopic"
        >
          <p class="text-black-500">{{ selectedChat.topic }}</p>
          <p class="text-info hover-target">Edit</p>
        </div>
      </div>

      <ChannelMembersInfoVue
        :showMemberClickListener="this.openChannelDetailMemberModal"
        :channelId="selectedChat.id"
        :channelName="selectedChat.name"
      />
    </div>
  </div>
  <ChatDetailModal
    v-if="modalOpen"
    :chat="currentChannel"
    :toggleModal="toggleShowModal"
    class="m-auto absolute inset-x-0"
  />
  <edit-topic-modal
    v-if="topicModal"
    :chat="selectedChat"
    :closeModal="toggleEditTopic"
  />
</template>

<script>
import ChatDetailModal from '../../containers/ChatDetailModal.vue';
import ChannelMembersInfoVue from './ChannelMembersInfo.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import editTopicModal from '../channeldetail/editTopicModal.vue';
export default {
  name: 'ChannelInfo',
  components: { ChatDetailModal, ChannelMembersInfoVue, editTopicModal },
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { ChannelDetailStore, joinedChannels, channelStore, selectedChat };
  },
  data() {
    return {
      modalOpen: false,
      currentChannel: {},
      topicModal: false,
    };
  },
  methods: {
    toggleShowModal() {
      if (!this.modalOpen) {
        this.ChannelDetailStore.setSelectedOption('about');
        this.getCurrentChannel();
        this.channelStore.setCurrentChannel(this.currentChannel);
      }
      this.modalOpen = !this.modalOpen;
    },
    openChannelDetailMemberModal(open) {
      this.ChannelDetailStore.setSelectedOption('members');
      this.modalOpen = open;
    },
    getCurrentChannel() {
      this.currentChannel =
        this.channelStore.joinedChannels.find(
          obj => obj.id === this.selectedChat.id
        ) ||
        this.channelStore.starChannels.find(
          obj => obj.id === this.selectedChat.id
        );
    },
    toggleEditTopic() {
      this.topicModal = !this.topicModal;
    },
  },
};
</script>
<style>
.hover-trigger .hover-target {
  display: none;
}

.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
