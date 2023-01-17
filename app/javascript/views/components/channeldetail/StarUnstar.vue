<template>
  <div class="w-10 cursor-pointer" @click="markChannel">
    <div v-if="selectedChat.favourite_id">
      <i
        class="fa-solid fa-star border border-black-300 px-4 rounded p-2 ml-6 m-2"
      ></i>
    </div>
    <div v-else>
      <i
        class="fa-regular fa-star border border-black-300 px-4 rounded p-2 ml-6 m-2"
      ></i>
    </div>
  </div>
</template>

<script>

import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { markStar } from '../../../modules/starunstar/starunstar.js';
import { useMessageStore } from '../../../stores/useMessagesStore';
export default {
  components: { markStar },
   setup() {
     const channelStore = useChannelStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return {
      selectedChat,
      channelStore
    };
  },
  methods: {
    markChannel() {
      markStar(this.selectedChat, this.channelStore);
    },
  },
};
</script>
