<template>
  <div class="overflow-auto chatBody">
    <PinnedConversationModel />
    <div v-for="message in messages" :key="message.id" :id="message.created_at">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage && !message.parent_message_id">
        <n-divider v-if="isToday" class="text-xs relative" @click="toggleToday" v-on:click.self="toggleToday">
          <div>
            <p class="font-normal text-xs border px-4 py-1 rounded-full">
              {{ $t('chat.today') }}
            </p>
          </div>
          <div v-if="jumpToDateTodayToggle" @close="toggleToday" class="absolute top-0 mt-8 w-1/5 z-10">
            <JumpToDateVue />
          </div>
        </n-divider>
        <n-divider v-else class="text-xs">
          <p
            class="font-normal text-xs border px-4 py-1 rounded-full"
            @click="toggleNotToday"
          >
            {{ new Date(message.created_at).toDateString() }}
          </p>
          <div v-if="jumpToDateToggle" class="absolute top-0 mt-8 w-1/5 z-10">
            <JumpToDateVue />
          </div>
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
import JumpToDateVue from '../../widgets/JumpToDate.vue';
export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NDivider,
    NButton,
    NSpace,
    PinnedConversationModel,
    JumpToDateVue,
  },
  data() {
    return {
      messages: [],
      jumpToDateTodayToggle: false,
      jumpToDateToggle: false,
      prevMessage: null,
      typeJump: {
        today: false,
        not_today: false,
      },
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
      currMessage,
    };
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.currMessage;
      this.currMessage = message;
    },
    toggleToday() {
      this.jumpToDateTodayToggle = !this.jumpToDateTodayToggle;
    },
    toggleNotToday() {
      this.jumpToDateToggle = !this.jumpToDateToggle;
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
  height: 60vh;
  max-height: 60vh;
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
