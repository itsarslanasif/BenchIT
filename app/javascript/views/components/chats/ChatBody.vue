<template>
  <div class="overflow-auto chatBody" ref="chatBody">
    <PinnedConversationModal />
    <ChatDetail />
    <div
      v-for="message in messages"
      :key="message.id"
      :id="getDate(message.created_at)"
    >
      <div :id="message.id">
        {{ setMessage(message) }}
        <div v-if="!isSameDayMessage && !message.parent_message_id">
          <n-divider
            v-if="isToday"
            class="text-xs relative"
            @click="toggleToday"
          >
            <div>
              <p class="date hover:bg-slate-50">
                {{ $t('chat.today') }}
              </p>
            </div>
            <div
              v-if="jumpToDateTodayToggle"
              class="absolute top-0 mt-8 w-1/5 z-10"
            >
              <JumpToDateVue
                :scrollToMessageByDate="scrollToMessageByDate"
                :today="true"
              />
            </div>
          </n-divider>
          <n-divider v-else class="text-xs relative">
            <p class="date hover:bg-slate-50" @click="toggleNotToday(message)">
              {{ new Date(message.created_at).toDateString() }}
            </p>
            <div
              v-if="jumpToDateToggle && message.id === selectedMessage.id"
              class="absolute top-0 mt-8 w-1/5 z-10"
            >
              <JumpToDateVue :scrollToMessageByDate="scrollToMessageByDate" />
            </div>
          </n-divider>
        </div>
        <n-divider
          v-if="newMessageFlag && oldestUnreadMessageId === message.id"
          title-placement="right"
        >
          <div class="text-primary">{{ $t('chat.new') }}</div>
        </n-divider>
        <MessageWrapper
          v-if="!message.parent_message_id"
          :currMessage="currMessage"
          :prevMessage="prevMessage"
        />
      </div>
    </div>
  </div>
</template>
<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NButton, NSpace, NDivider } from 'naive-ui';
import { storeToRefs } from 'pinia';
import PinnedConversationModal from '../pinnedConversation/pinnedConversationModal.vue';
import JumpToDateVue from '../../widgets/JumpToDate.vue';
import moment from 'moment';
import ChatDetail from '../../widgets/ChatDetail.vue';
export default {
  name: 'ChatBody',
  components: {
    MessageWrapper,
    NDivider,
    NButton,
    NSpace,
    PinnedConversationModal,
    JumpToDateVue,
    ChatDetail,
  },
  props: ['oldestUnreadMessageId'],
  data() {
    return {
      messages: [],
      jumpToDateTodayToggle: false,
      jumpToDateToggle: false,
      prevMessage: null,
      selectedMessage: {},
      newMessageFlag: true,
    };
  },
  mounted() {
    this.scrollToEnd();
  },
  beforeUnmount() {
    this.messages = this.prevMessage = this.selectedMessage = null;
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
      this.jumpToDateToggle = false;
    },
    toggleNotToday(message) {
      this.selectedMessage = message;
      this.jumpToDateToggle = !this.jumpToDateToggle;
      this.jumpToDateTodayToggle = false;
    },
    scrollToMessageByDate(date) {
      let message = {};
      let id = '';
      if (date === 'beginning_of_chat') {
        const beginningDate = new Date(this.messages[0].created_at);
        id = `${beginningDate.getFullYear()}-${beginningDate.getMonth()}-${beginningDate.getDate()}`;
      } else {
        id = `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`;
      }
      message = document.getElementById(id);
      this.scrollToMessage(message);
      this.jumpToDateTodayToggle = this.jumpToDateToggle = false;
    },
    scrollToMessage(message) {
      if (message) {
        message.scrollIntoView();
        message.classList.add('highlight');
      }
      this.jumpToDateTodayToggle = false;
      this.jumpToDateToggle = false;
    },
    getDate(created_at) {
      const dateInUTC = moment(new Date(created_at));
      return `${dateInUTC.year()}-${dateInUTC.month()}-${dateInUTC.date()}`;
    },
    scrollToEnd() {
      let body = this.$refs.chatBody;
      body.scrollTop = body.scrollHeight;
    },
  },
  updated() {
    const message_id = this.$route.params.message_id;
    if (message_id) {
      const message = document.getElementById(message_id);
      message.classList.add('highlight');
      message.scrollIntoView();
    }
    this.scrollToEnd();
    this.newMessageFlag = false;
  },
};
</script>
<style scoped>
.chatBody {
  height: 62.5vh;
  max-height: 100vh;
}

.highlight {
  animation: background-fade 10s;
}

@keyframes background-fade {
  0% {
    background: rgba(213, 215, 211, 215);
  }
}

.date {
  @apply font-normal text-xs border px-4 py-1 rounded-full;
}
</style>
