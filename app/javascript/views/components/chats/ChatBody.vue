<template>
  <div class="overflow-auto chatBody">
    <template v-for="(message, index) in messages" :key="index">
      {{ setMessage(message) }}
      <div
        v-if="!isSameDayMessage(messages[index - 1]?.sentAt, message?.sentAt)"
      >
        <n-divider>
          <p class="text-gray-600">
            {{
              isToday(message.sentAt) ? 'Today' : new Date(message.sentAt).toDateString()
            }}
          </p>
        </n-divider>
      </div>
      <MessageWrapper
        :curr-message="message"
        :prev-message="messages[index - 1]"
      />
    </template>
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
      messages: [],
      message: null,
      prevMessage: null,
    };
  },
  computed: {
    isToday() {
      return (
        new Date(this.message?.created_at).toDateString() === new Date().toDateString()
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.message?.created_at).toDateString() === new Date(this.prevMessage?.created_at).toDateString()
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

    isToday(sentAt) {
      return new Date(sentAt).toDateString() === new Date().toDateString();
    },

    isSameDayMessage(prevSentAt, currSentAt) {
      return (
        new Date(prevSentAt).toDateString() ===
        new Date(currSentAt).toDateString()
      );
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
