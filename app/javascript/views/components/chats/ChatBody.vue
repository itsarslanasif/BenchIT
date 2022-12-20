<template>
  <div class="overflow-auto chatBody">
    <PinnedConversationModel />
    <div v-for="message in messages" :key="message.id" :id="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage && !message.parent_message_id">
        <n-divider v-if="isToday" class="text-xs">
          <p class="font-normal text-xs">{{$t('chat.today')}}</p>
        </n-divider>
        <n-divider v-else class="text-xs text-black-500">
          <p class="font-normal text-xs text-black-500">{{ new Date(message.created_at).toDateString() }}</p>
        </n-divider>
      </div>
      <MessageWrapper
        v-if="!message.parent_message_id"
        :currMessage="currMessage"
        :prevMessage="prevMessage"
      />
    </div>
  </div>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NButton, NSpace, NDivider } from 'naive-ui';
import { storeToRefs } from 'pinia';
import PinnedConversationModel from '../pinnedConversation/pinnedConversationModel.vue';

export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NDivider,
    NButton,
    NSpace,
    PinnedConversationModel,
  },
  data() {
    return {
      messages: [],
      prevMessage: null,
    };
  },
  computed: {
    isToday() {
      return (
        new Date(this.currMessage?.created_at).toDateString() ===
        new Date().toDateString()
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.currMessage?.created_at).toDateString() ===
        new Date(this.prevMessage?.created_at).toDateString()
      );
    },
  },
  setup() {
    const messageStore = useMessageStore();
    const { messages, currMessage } = storeToRefs(messageStore);
    return {
      messages,
      currMessage
    };
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.currMessage;
      this.currMessage = message
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
  height: 62.5vh;
  max-height: 100vh;
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
