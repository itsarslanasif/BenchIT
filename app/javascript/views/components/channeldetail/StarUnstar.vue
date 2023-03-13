<template>
  <div>
    <span
      class="flex items-center border rounded h-8 px-3 ml-4 hover:bg-transparent cursor-pointer"
      v-on="{ click: isProfile ? null : markChannel }"
    >
      <i v-if="chat.favourite_id" class="fa-solid fa-star" />
      <i v-else class="fa-regular fa-star" />
    </span>
  </div>
</template>

<script>
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { markStar } from '../../../modules/starunstar/starunstar.js';
export default {
  components: { markStar },
  props: { chat: Object },
  setup() {
    const channelStore = useChannelStore();
    const { currentChannel } = storeToRefs(channelStore);
    return {
      channelStore,
      currentChannel,
    };
  },
  computed: {
    isProfile() {
      return this.chat.conversation_type === 'Profile';
    },
  },
  methods: {
    markChannel() {
      markStar(this.currentChannel, this.channelStore);
    },
  },
};
</script>
