<template>
  <div class="p-1 relative">
    <div class="header">
      <div
        @click="OpenChannelDetailModal(true)"
        class="headerContainer hover:bg-transparent rounded cursor-pointer"
      >
        <i class="fas fa-hashtag self-center fa-lg mr-1"></i>
        <p class="text-xl font-bold self-center mr-1">{{ channel.name }}</p>
        <i class="fa-solid fa-chevron-down self-center fa-lg"></i>
      </div>
      <div
        class="
          flex
          items-center
          justify-center
          mr-2
          w-8
          h-8
          rounded
          hover:bg-transparent
          cursor-pointer
        "
      >
        <i class="fas fa-user-plus self-center fa-lg"></i>
      </div>
    </div>
  </div>

  <ChannelDetailModal
    v-if="modalOpen"
    :channelName="channel.name"
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
.headerContainer {
  display: flex;
  overflow-y: hidden;
  text-overflow: ellipsis;
  scrollbar-color: dark;
  padding: 5px;
}

.header {
  align-items: center;
  border-bottom: 0.5px solid gray;
  display: flex;
  height: fit-content;
  justify-content: space-between;
  padding: 5px;
}

.phone-btn {
  align-items: center;
  border-radius: 3px;
  display: flex;
  height: 30px;
  justify-content: center;
  margin: 0px 10px 0px 10px;
  width: 30px;
}

.phone-btn:hover {
  background-color: rgb(230, 232, 234);
  cursor: pointer;
}

.avatar__badge {
  background-color: rgb(54, 151, 54);
  border-radius: 50%;
  border: 2px solid white;
  height: 12px;
  margin-left: -12px;
  margin-top: 18px;
  position: relative;
  width: 12px;
}

.name {
  color: rgb(52, 51, 51);
  font-size: 20px;
  font-weight: 600;
  margin: 0 5px 0 0;
}
</style>
