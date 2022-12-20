<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div
        @click="OpenChannelDetailModal(true)"
        class="flex mx-3 px-1 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
      >
        <i class="fas fa-hashtag self-center fa-lg mr-1"></i>
        <p class="text-xl font-bold self-center mr-1">{{ channel.name }}</p>
        <i class="fa-solid fa-chevron-down self-center fa-xs"></i>
      </div>
      <div
        class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer"
      >
      <AddPeopleToChannel/>
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
import AddPeopleToChannel from './AddPeopleToChannel.vue'

export default {
  name: 'ChannelInfo',
  components: { ChannelDetailModal, AddPeopleToChannel },
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
  .custom-border {
    border-bottom: 0.5px solid gray;
  }
</style>
