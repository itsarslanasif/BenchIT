<template>
  <div class="container">
    <template v-for="message in messages" :key="message.id">
      {{ setMessageTime(message.sentAt) }}
      <div v-if="!isSameDayMessage">
        <p class="messageTimestamp">
          {{ isToday ? 'Today' : new Date(messageTime).toDateString() }}
        </p>
      </div>
      <MessageWrapper :message="message" />
    </template>
  </div>
</template>

<script>
import MessageWrapper from './MessageWrapper.vue';
import messages from './data/messages';
export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
  },
  data() {
    return {
      messages: messages,
      messageTime: null,
      prevMessageTime: null,
    };
  },
  computed: {
    isToday() {
      return (
        new Date(this.messageTime).toDateString() === new Date().toDateString()
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.messageTime).toDateString() ===
        new Date(this.prevMessageTime).toDateString()
      );
    },
  },
  methods: {
    setMessageTime(time) {
      this.prevMessageTime = this.messageTime;
      this.messageTime = time;
    },
  },
};
</script>
<style scoped>
.container {
  float: left;
  height: 100vh;
  margin-top: 10px;
  overflow: auto;
  width: 100%;
}
.messageTimestamp {
  color: grey;
  font-size: small;
  margin: 0px;
  text-align: center;
}
hr {
  border-top: 1px solid rgb(108, 107, 107);
  border: 20px;
  margin: 0px 0px 5px 0px;
}
</style>
