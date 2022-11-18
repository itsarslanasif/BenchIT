<template>
  <div class="container">
    <template v-for="message in messages" :key="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
        <n-divider>
          <p class="messageTimestamp">
            {{
              isToday ? 'Today' : new Date(message.created_at).toDateString()
            }}
          </p>
        </n-divider>
      </div>
      <MessageWrapper :curr-message="message" :prev-message="prevMessage" />
    </template>
  </div>
</template>
<script>
import MessageWrapper from './MessageWrapper.vue';
import { NButton, NSpace, NDivider } from 'naive-ui';
export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NButton,
    NSpace,
    NDivider,
  },
  props: ['messages'],
  data() {
    return {
      message: null,
      prevMessage: null,
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
  height: 60vh;
  overflow-y: auto;
  width: 100%;
}
.messageTimestamp {
  color: grey;
  font-size: small;
  margin: 0px;
  text-align: center;
}
</style>
