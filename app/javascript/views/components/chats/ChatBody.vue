<template>
  <div class="infi-scroll-comp-root">
    <div class="overflow-auto chatBody" ref="chatBody">
      <PinnedConversationModal />
      <ChatDetail />
      <div v-if="showSpinner" class="text-center">
        <div class="spinner"></div>
      </div>
      <div class="sentinel" ref="sentinel"></div>
      <div
        v-for="message in messages"
        :key="message.id"
        :id="getDate(message.created_at)"
      >
        <div :id="message.id">
          {{ setMessage(message) }}
          <div
            v-if="
              (!isSameDayMessage && !message.parent_message_id) ||
              isFirstMessage
            "
          >
            <n-divider
              v-if="isToday"
              class="text-xs relative cursor-pointer"
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
                  :toggleShow="toggleToday"
                />
              </div>
            </n-divider>
            <n-divider v-else class="text-xs relative cursor-pointer">
              <p
                class="date hover:bg-slate-50"
                @click="toggleNotToday(message)"
              >
                {{ new Date(message.created_at).toDateString() }}
              </p>
              <div
                v-if="jumpToDateToggle && message.id === selectedMessage.id"
                class="absolute top-0 mt-8 w-1/5 z-10"
              >
                <JumpToDateVue
                  :scrollToMessageByDate="scrollToMessageByDate"
                  :toggleShow="toggleNotToday"
                />
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
      <div v-if="unsentQueue.length">
        <div v-for="message in unsentQueue" :key="message.id">
          <MessageWrapper
            v-if="isSameChat(message)"
            :currMessage="message"
            :prevMessage="prevMessage"
            :isUnsentMessage="true"
          />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NButton, NSpace, NDivider } from 'naive-ui';
import { storeToRefs } from 'pinia';
import { useConnectionStore } from '../../../stores/useConnectionStore';
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
      jumpToDateTodayToggle: false,
      jumpToDateToggle: false,
      prevMessage: [],
      selectedMessage: {},
      timeLimit: 0,
      showSpinner: false,
      newMessageFlag: true,
      firstMount: true,
      messageScrolledIntoView: false,
    };
  },
  mounted() {
    this.setUpInterSectionObserver();
  },
  beforeUnmount() {
    this.messages = this.prevMessage = this.selectedMessage = [];
    this.hasMoreMessages = true;
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
    isFirstMessage() {
      if (this.messages) {
        return this.firstMessageId === this.currMessage?.id;
      }
    },
    firstMessageId() {
      return this.messages[0]?.id;
    },
  },
  setup() {
    const messageStore = useMessageStore();
    const connectionStore = useConnectionStore();
    const {
      messages,
      currMessage,
      hasMoreMessages,
      newMessageSent,
      selectedChat,
    } = storeToRefs(messageStore);
    const { unsentQueue } = storeToRefs(connectionStore);
    return {
      messages,
      currMessage,
      hasMoreMessages,
      newMessageSent,
      unsentQueue,
      selectedChat,
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
        setTimeout(() => {
          message.classList.remove('highlight');
        }, 1000);
      }
      this.jumpToDateTodayToggle = false;
      this.jumpToDateToggle = false;
    },
    getDate(created_at) {
      const dateInUTC = moment(new Date(created_at));
      return `${dateInUTC.year()}-${dateInUTC.month()}-${dateInUTC.date()}`;
    },
    setUpInterSectionObserver() {
      let options = {
        root: this.$refs['chatBody'],
        margin: '10px',
      };
      this.listEndObserver = new IntersectionObserver(
        this.handleIntersection,
        options
      );
      this.listEndObserver.observe(this.$refs['sentinel']);
    },
    handleIntersection([entry]) {
      if (entry.isIntersecting) {
        this.recordScrollPosition();
        this.$emit('load-more-messages');
      }
    },
    recordScrollPosition() {
      let node = this.$refs['chatBody'];
      this.previousScrollHeightMinusScrollTop =
        node.scrollHeight - node.scrollTop;
    },
    restoreScrollPosition() {
      if (!this.firstMount) {
        let node = this.$refs['chatBody'];
        node.scrollTop =
          node.scrollHeight - this.previousScrollHeightMinusScrollTop;
      }
    },
    scrollToEnd() {
      if (this.newMessageSent || this.firstMount)
        setTimeout(() => {
          let chatBody = this.$refs.chatBody;
          chatBody.scrollTop = chatBody.scrollHeight;
          this.newMessageSent = this.firstMount = false;
        }, 0);
    },
    loadAndCheckMessage(message_id) {
      try {
        const message = document.getElementById(message_id);
        message.scrollIntoView();
        const rect = message.getBoundingClientRect();
        const viewportWidth = window.innerWidth + window.scrollX;
        const viewportHeight = window.innerHeight + window.scrollY;
        const isInViewport =
          rect.top >= 0 &&
          rect.left >= 0 &&
          rect.bottom <= viewportHeight &&
          rect.right <= viewportWidth;
        if (isInViewport) {
          message.scrollIntoView({ block: 'center' });
          message.classList.add('highlight');
          this.messageScrolledIntoView = true;
          return;
        } else {
          this.$emit('load-more-messages');
        }
      } catch (e) {
        this.$emit('load-more-messages');
      }
    },
    isSameChat(message) {
      if (this.selectedChat.conversation_type) {
        return (
          this.selectedChat.id == message.conversation_id &&
          this.selectedChat.conversation_type.toLowerCase() ==
            message.conversation_type.slice(0, -1)
        );
      }
    },
  },
  updated() {
    const message_id = this.$route.params.message_id;

    if (message_id) {
      this.loadAndCheckMessage(message_id);
    }

    if (!this.messageScrolledIntoView) {
      this.newMessageFlag = false;
      this.scrollToEnd();
      this.restoreScrollPosition();
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
  animation: background-fade 5s;
}

@keyframes background-fade {
  0% {
    background: rgba(236, 219, 145, 0.789);
  }
}

.date {
  @apply font-normal text-xs border px-4 py-1 rounded-full;
}
</style>
