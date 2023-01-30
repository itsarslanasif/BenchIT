<template>
  <div class="py-3 px-4 flex gap-4 text-lg bg-white border border-black-400 rounded-md">
    <font-awesome-icon icon="fa-solid fa-pen" class="text-warning hover:text-warningHover" />
    <font-awesome-icon icon="fa-solid fa-paper-plane" class="text-success hover:text-successHover"
      @click.stop="sendMessageNow" />
    <font-awesome-icon icon="fa-solid fa-file-pen" class="text-info hover:text-infoHover" />
    <font-awesome-icon icon="fa-solid fa-trash" class="text-danger hover:text-dangerHover"
      @click.stop="deleteScheduled" />
  </div>
</template>

<script>
import { useMessageStore } from '../../stores/useMessagesStore';
export default {
  props: ['payload'],
  setup() {
    const messageStore = useMessageStore()
    return {
      messageStore
    }
  },
  methods: {
    sendMessageNow() {
      this.messageStore.sendMessageNow(this.payload)
    },
    deleteScheduled() {
      this.messageStore.deleteScheduledMessage(this.payload)
    }
  }
}
</script>
