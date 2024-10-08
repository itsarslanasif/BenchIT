<template>
  <div class="relative">
    <div
      class="border-b border-light px-1 h-12 items-center flex justify-between"
    >
      <div
        class="flex px-1 my-2 overflow-x-hidden text-ellipsis items-center rounded cursor-pointer"
      >
        <div
          @click="toggleShowModal"
          v-if="selectedChat"
          class="flex px-1 mx-3 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
        >
          <n-avatar
            class="mr-1 self-center"
            size="small"
            :src="selectedChat.image_url"
          />
          <span
            v-if="selectedChat.is_active"
            class="bg-green-700 rounded-full border-white border-2 h-3 w-3 relative -ml-3 mt-5"
          />
          <span
            v-else
            class="bg-white away rounded-full border-black border-2 h-2 w-2 relative"
          />

          <span v-if="selectedChat">
            <p class="text-xl self-center font-semibold pl-1">
              {{ selectedChat.username }}
            </p>
          </span>
          <span v-if="selectedChat.status" class="self-center mx-1">
            <n-tooltip trigger="hover">
              <template #trigger>
                {{ selectedChat.status.emoji }}
              </template>
              <span> {{ selectedChat.status.text }} </span>
            </n-tooltip>
          </span>
          <i class="fa-solid fa-chevron-down self-center mx-1" />
        </div>
        <div
          v-if="selectedChat.topic"
          class="flex items-center gap-1 hover-trigger"
          @click="toggleEdittopic"
        >
          <p class="text-black-500">{{ selectedChat.topic }}</p>
          <p class="text-info hover-target hover:underline">Edit</p>
        </div>
      </div>
      <div
        class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer"
      >
        <i class="fa-solid fa-phone self-center" />
      </div>
    </div>
    <ChatDetailModal
      v-if="showChatDetail"
      :chat="selectedChat"
      :toggleModal="toggleShowModal"
      class="m-auto absolute inset-x-0"
    />
    <edit-topic-modal
      v-if="topicModal"
      :closeModal="toggleEdittopic"
      :chat="selectedChat"
    />
  </div>
</template>

<script>
import { NAvatar, NTooltip } from 'naive-ui';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore.js';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore.js';
import { storeToRefs } from 'pinia';
import ChatDetailModal from '../../containers/ChatDetailModal.vue';
import { ref } from 'vue';
import EditTopicModal from '../channeldetail/EditTopicModal.vue';

export default {
  components: { NAvatar, NTooltip, ChatDetailModal, EditTopicModal },
  setup() {
    const directMessagesStore = useDirectMessagesStore();
    const leftPaneStore = useLeftpaneStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    let showChatDetail = ref(false);
    const openChatDetailModal = open => {
      showChatDetail.value = open;
    };
    const toggleShowModal = () => {
      showChatDetail.value = !showChatDetail.value;
    };
    return {
      directMessagesStore,
      selectedChat,
      leftPaneStore,
      toggleShowModal,
      showChatDetail,
      openChatDetailModal,
    };
  },
  data() {
    return {
      topicModal: false,
    };
  },
  methods: {
    toggleEdittopic() {
      this.topicModal = !this.topicModal;
    },
  },
};
</script>

<style scoped>
.custom-border {
  border-bottom: 0.5px solid rgba(19, 19, 19, 0.139);
}
.away {
  margin-left: -10px;
  margin-top: 22px;
  outline: 2px solid rgb(255, 255, 255);
}
.hover-trigger .hover-target {
  display: none;
}

.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
