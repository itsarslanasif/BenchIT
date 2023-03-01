<template>
  <div class="w-full">
    <div
      class="bg-slate-50 border border-black-300 rounded m-3 h-48 flex flex-col justify-center items-center gap-2"
    >
      <div class="font-bold text-base text-center">
        <div>
          <font-awesome-icon icon="fa-hashtag" class="text-sm" />
          {{ selectedChat.name }}
        </div>
        <div class="text-sm font-normal text-black-500" v-if="selectedChat.description">
          {{ selectedChat.description }}
        </div>
      </div>
      <div class="flex gap-4">
        <div
          @click="toggleShowModal"
          class="px-5 py-1 border bg-white border-black-500 rounded hover:bg-slate-50 cursor-pointer duration-200"
        >
          {{ $t('actions.details') }}
        </div>
        <div
          class="bg-success px-5 py-1 rounded hover:bg-successHover cursor-pointer text-white duration-200"
          @click="joinChannel"
        >
          {{ $t('actions.join_channel') }}
        </div>
      </div>
    </div>
  </div>
  <ChatDetailModal
    v-if="modalOpen"
    :chat="currentChannel"
    :toggleShow="toggleShowModal"
    class="m-auto mt-12 absolute top-0 inset-x-0"
  />
</template>
<script>
import ChatDetailModal from '../containers/ChatDetailModal.vue';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
export default {
  components: {
    ChatDetailModal,
  },
  setup() {
    const messageStore = useMessageStore();
    const channelStore = useChannelStore();
    const ChannelDetailStore = useChannelDetailStore();
    const leftPaneStore = useLeftpaneStore();
    const { selectedChat } = storeToRefs(messageStore);
    return {
      selectedChat,
      channelStore,
      ChannelDetailStore,
      leftPaneStore,
    };
  },
  props: ['joinedTheChannel'],
  data() {
    return {
      modalOpen: false,
    };
  },
  methods: {
    toggleShowModal() {
      this.modalOpen = !this.modalOpen;
    },
    async joinChannel() {
      await this.channelStore.joinChannel(this.selectedChat.id);
      this.joinedTheChannel();
    },
  },
};
</script>
