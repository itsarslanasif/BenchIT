<template>
  <div class="overflow-auto chatBody">
    <div v-for="message in messages" :key="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
          <p class="text-gray-600">
            {{
              isToday ? 'Today' : new Date(message.created_at).toDateString()
            }}
          </p>
      </div>
      <MessageWrapper :currMessage="message" :prevMessage="prevMessage" />
    </div>
  </div>
</template>
<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NButton, NSpace, NDivider } from 'naive-ui';
import { storeToRefs } from 'pinia';

export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NDivider,
    NButton,
    NSpace,
  },
  data() {
    return {
      message: null,
      prevMessage: null,
      messages: [],
    };
  },
  computed: {
    isToday() {
      return (
        new Date(this.message?.created_at).toDateString() ===
        new Date().toDateString()
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.message?.created_at).toDateString() ===
        new Date(this.prevMessage?.created_at).toDateString()
      );
    },
  },
  setup() {
    const messageStore = useMessageStore();
    const { messages } = storeToRefs(messageStore);
    return {
      messages
    };
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.message;
      this.message = message;
    },
  },
};
</script>
<style scoped>
.container {
  float: left;
  overflow-y: auto;
}

.chatBody {
  height: 57vh;
}
</style>
