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
            (!isSameDayMessage && !message.parent_message_id) || isFirstMessage
          "
        >
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
      jumpToDateTodayToggle: false,
      jumpToDateToggle: false,
      prevMessage: [],
      selectedMessage: {},
      timeLimit: 0,
      showSpinner: false,
      newMessageFlag: true,
    };
  },
  mounted() {
    this.scrollToEnd();
    this.setUpInterSectionObserver();
  },
  beforeUnmount() {
    this.messages = this.prevMessage = this.selectedMessage = [];
    this.currentPage = 1
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
    const { messages, currMessage, currentPage } = storeToRefs(messageStore);
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
      let node = this.$refs["chatBody"];
      node.scrollTop = node.scrollHeight;
    },
    // handleScroll() {
    // console.log('scrolling like a champ')
    //   if (this.$refs.chatBody.scrollTop === 0) {
    //     const currentTime = new Date().getTime();
    //     if (currentTime < this.timeLimit + 3000) {
    //       this.showSpinner = true;
    //       setTimeout(() => {
    //         this.showSpinner = false;
    //       }, 3000);
    //       return
    //     }
    //     this.timeLimit = currentTime
    //     this.$emit('load-more-messages')
    //   }
    // },
    setUpInterSectionObserver() {
      let options = {
        root: this.$refs["chatBody"],
        margin: "10px",
      };
      this.listEndObserver = new IntersectionObserver(
        this.handleIntersection,
        options
      );
      this.listEndObserver.observe(this.$refs["sentinel"]);
    },
    handleIntersection([entry]) {
      if (entry.isIntersecting) {
        console.log("sentinel intersecting");
        this.$emit('load-more-messages')
        this.recordScrollPosition()
        this.$nextTick(() => {
          this.restoreScrollPosition();
        });
      }
      if (entry.isIntersecting && this.canLoadMore && !this.isLoadingMore) {
        this.loadMore();
      }
    },
    recordScrollPosition() {
      let node = this.$refs["chatBody"];
      this.previousScrollHeightMinusScrollTop =
        node.scrollHeight - node.scrollTop;
      console.log(this.previousScrollHeightMinusScrollTop)
    },
    restoreScrollPosition() {
      console.log('restore')
      let node = this.$refs["chatBody"];
      console.log(node.scrollHeight)
      node.scrollTop =
        node.scrollHeight - this.previousScrollHeightMinusScrollTop;
      console.log(node.scrollTop);
    }
  
  },
  updated() {
    const message_id = this.$route.params.message_id;
    if (message_id) {
      const message = document.getElementById(message_id);
      if (message) {
        message.classList.add('highlight');
        message.scrollIntoView();
        return;
      }
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
  animation: background-fade 5s;
}

@keyframes background-fade {
  0% {
    background: rgba(253, 245, 221, 255);
  }
}

.date {
  @apply font-normal text-xs border px-4 py-1 rounded-full;
}
</style>
