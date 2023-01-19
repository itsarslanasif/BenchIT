<template>
  <div v-if="toggleDetailModal" class="m-auto absolute inset-x-0">
    <ChannelDetailModal />
  </div>
  <div class="w-full">
    <div
      class="bg-slate-50 border border-black-300 rounded m-3 h-48 flex flex-col justify-center items-center gap-2"
    >
      <div class="font-bold text-base"># tour-de-naran</div>
      <div class="flex gap-4">
        <div @click="toggle"
          class="px-5 py-1 border bg-white border-black-500 rounded hover:bg-slate-50 cursor-pointer duration-200"
        >
          Details
        </div>
        <div
          class="bg-success px-5 py-1 rounded hover:bg-successHover cursor-pointer text-white duration-200"
        >
          Join Channel
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import ChannelDetailModal from '../containers/ChannelDetailModal.vue';
export default {
  components: {
    ChannelDetailModal,
  },
  data() {
    return {
      toggleDetailModal: false,
    };
  },
  methods: {
    toggle() {
      this.toggleDetailModal = !this.toggleDetailModal;
    },
  },
};
</script>
