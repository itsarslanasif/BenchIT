<template>
  <div class="p-1 relative">
    <div class="header items-center flex p-1 justify-between">
      <div
        @click="OpenChannelDetailModal(true)"
        class="flex p-1 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
      >
        <i class="fas fa-hashtag self-center fa-lg mr-1"></i>
        <p class="text-xl font-bold self-center mr-1">{{ channel.name }}</p>
        <i class="fa-solid fa-chevron-down self-center fa-lg"></i>
      </div>
      <div
        class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer"
      >
        <i class="fas fa-user-plus self-center fa-lg"></i>
      </div>
    </div>
  </div>
  <ChannelDetailModal
    v-if="modalOpen"
    :channelName="channel.name"
    :channelId="channel.id"
    :detailsopen="this.OpenChannelDetailModal"
    class="m-auto absolute inset-x-0"
  />
</template>

<script>
import ChannelDetailModal from '../../containers/ChannelDetailModal.vue';
export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal },
  props: ['channel'],
  data() {
    return {
      modalOpen: false,
    };
  },

  methods: {
    OpenChannelDetailModal(open) {
      this.modalOpen = open;
    },
  },
};
</script>
<style scoped>
  .header {
    border-bottom: 0.5px solid gray;
  }
</style>
