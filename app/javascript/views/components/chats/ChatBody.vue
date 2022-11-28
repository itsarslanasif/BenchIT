<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/no-template-key -->
<!-- eslint-disable vue/no-template-shadow -->
<!-- eslint-disable vue/valid-v-for -->
<template>
  <div class="overflow-auto chatBody">
    <template v-for="message in messages" :key="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
        <n-divider>
          <p class="text-gray-600">
            {{ isToday ? 'Today' : new Date(message.sentAt).toDateString() }}
          </p>
        </n-divider>
      </div>
      <MessageWrapper :curr-message="message" :prev-message="prevMessage" />
    </template>
  </div>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import messages from '../../../modules/data/messages';
import { NDivider } from 'naive-ui';

export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NDivider,
  },
  data() {
    return {
      messages: messages,
      message: null,
      prevMessage: null,
    };
  },
  computed: {
    isToday() {
      return (
        new Date(this.message?.sentAt).toDateString() ===
        new Date().toDateString()
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.message?.sentAt).toDateString() ===
        new Date(this.prevMessage?.sentAt).toDateString()
      );
    },
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
