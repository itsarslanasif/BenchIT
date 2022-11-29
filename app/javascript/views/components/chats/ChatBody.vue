<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/no-template-key -->
<!-- eslint-disable vue/no-template-shadow -->
<!-- eslint-disable vue/valid-v-for -->
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
