<template>
  <div class="overflow-auto chatBody">
    <template v-for="message in messages" :key="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
        <n-divider class="w-full">
          <p class="absolute text-gray-600 text-sm m-0 text-center">
            {{ isToday ? 'Today' : new Date(message.sentAt).toDateString() }}
          </p>
        </n-divider>
      </div>
      <MessageWrapper :currMessage="message" :prevMessage="prevMessage" />
    </template>
  </div>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import messages from '../../../modules/data/messages';
import { NButton, NSpace, NDivider } from 'naive-ui';

export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NButton,
    NSpace,
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
  /* height: 100vh; */
  overflow-y: auto;
}

.chatBody{
  height: 57vh;
}

</style>
