<template>
  <div class="overflow-auto chatBody">
    <pinnedConversationModel></pinnedConversationModel>
    <div v-for="message in messages" :key="message.id" :id="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
        <p class="text-gray-600">
          {{ isToday ? 'Today' : new Date(message.created_at).toDateString() }}
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
import pinnedConversationModel from '../pinnedConversation/pinnedConversationModel.vue'

export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NDivider,
    NButton,
    NSpace,
    pinnedConversationModel,
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
      messages,
    };
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.message;
      this.message = message;
    },
  },
  updated() {
    const message_id = this.$route.params.message_id;

    if (message_id) {
      const message = document.getElementById(message_id);
      message.scrollIntoView();
      message.classList.add('highlight');
    }
  },
};

</script>
<style scoped>
.chatBody {
  height: 57vh;
}

.highlight {
  animation: background-fade 7s;
}

@keyframes background-fade {
  0% {
    background: rgba(253, 245, 221, 255);
  }
}
</style>
