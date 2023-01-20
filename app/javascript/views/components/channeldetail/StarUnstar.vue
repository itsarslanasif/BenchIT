<template>
  <div>
    <div v-if="this.currentChannel?.favourite_id">
      <span @click="markChannel"> <i class="fa-solid fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i></span>
    </div>
    <div v-else>
      <span @click="markChannel"><i class="fa-regular fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i></span>
    </div>
  </div>
</template>

<script>

import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { markStar } from '../../../modules/starunstar/starunstar.js';
export default {
  components: { markStar },
  setup() {
    const channelStore = useChannelStore();
    const { currentChannel } = storeToRefs(channelStore);
    return {
      channelStore,
      currentChannel,
    };
  },
  methods: {
    markChannel() {
      markStar(this.currentChannel, this.channelStore);
    },
  },
};
</script>
