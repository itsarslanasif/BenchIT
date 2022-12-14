<template>
  <div class="relative">
    <div class="custom-border h-12 px-1 items-center flex justify-between">
      <div
        @click="goToMessage"
        class="flex px-1 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
        >
        <p class="text-lg font-semibold self-center mr-2">{{$t('chat.thread')}}</p>
        <p class="text-md text-black-600 self-center mr-1">{{ threadName }}</p>
      </div>
      <div
        @click="threadStore.toggleShow(false)"
        class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer"
      >
        <i class="fas fa-xmark self-center fa-xs"></i>
      </div>
    </div>
  </div>
</template>

<script>
import { useThreadStore } from '../../../stores/useThreadStore';
export default {
  name: 'ThreadHeader',
  props: ['threadName', 'messageId'],
  methods: {
    goToMessage() {
      this.$router.push(this.messageId);
    },
  },
  setup() {
    const threadStore = useThreadStore();
    return {threadStore};
  },
};
</script>
<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
</style>
