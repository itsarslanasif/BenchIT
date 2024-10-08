<template>
  <div ref="body" class="scrollable bg-gray-100 mb-2">
    <div v-for="message in sentMessages" :key="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage || isFirstMessage">
        <div v-if="isToday" class="text-xs text-black-900 font-bold m-4">
          <p>{{ $t('chat.today') }}</p>
        </div>
        <div v-else class="text-xs text-black-900 font-bold m-4">
          <p>{{ new Date(message.created_at).toDateString() }}</p>
        </div>
      </div>
      <div
        @click="handleClick(message)"
        class="bg-transparent mx-4 my-1 mb-1 gap-1 rounded cursor-pointer flex p-4 hover:bg-black-200 duration-200"
      >
        <div class="min-w-fit ml-1">
          <span
            v-if="message.conversationable_type === 'Profile'"
            class="w-12 h-12"
          >
            <n-avatar :src="getImageSrc(message)" :size="40" />
          </span>
          <div
            class="bg-secondaryHover w-10 h-10 rounded flex items-center justify-center text-base"
            v-else
          >
            <div
              v-if="
                message.conversationable_type === $t('conversation.channel')
              "
            >
              <font-awesome-icon :icon="getIcon(message)" />
            </div>
            <div v-else>
              <font-awesome-icon icon="fa-user-group" />
            </div>
          </div>
        </div>
        <div class="ml-3 flex justify-center flex-col">
          <div
            v-if="
              !message.is_threaded &&
              message.conversationable_type === $t('conversation.profile')
            "
            class="font-semibold"
          >
            {{ message.receiver_name }}
          </div>
          <div
            v-else-if="
              !message.is_threaded &&
              message.conversationable_type === $t('conversation.channel')
            "
            class="font-semibold"
          >
            {{ message.channel_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded &&
              message.conversationable_type === $t('conversation.channel')
            "
            class="font-semibold"
          >
            {{ $t('heading.thread_in') + message.channel_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded &&
              message.conversationable_type === $t('conversation.profile')
            "
            class="font-semibold"
          >
            {{ $t('heading.thread_in') + message.receiver_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded &&
              message.conversationable_type === $t('conversation.group')
            "
            class="font-semibold"
          >
            {{ $t('heading.thread_in') }}
          </div>
          <div
            v-else-if="
              !message.is_threaded &&
              message.conversationable_type === $t('conversation.group')
            "
            class="font-semibold"
          >
            {{ $t('heading.message_in') }} {{ message.group_name }}
          </div>
          <span v-for="block in messageBlocks" :key="block">
            <MessageSection v-if="block.type === 'section'" :section="block" />
          </span>
        </div>
        <div class="ml-auto mt-auto text-xs w-30 text-black-600">
          {{ time }}
        </div>
      </div>
    </div>
    <div ref="sentinel"></div>
    <div class="flex items-center justify-center">
      <n-spin v-if="!isLastPage" class="self-center my-2" size="small" />
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar, NDivider, NSpin } from 'naive-ui';
import { useProfileStore } from '../../../stores/useProfileStore';
import { storeToRefs } from 'pinia';
import { useChannelStore } from '../../../stores/useChannelStore';
import MessageSection from '../messages/MessageSection.vue';
import { useDraftAndSentMessagesStore } from '../../../stores/useDraftAndSentMessagesStore';

export default {
  components: {
    NAvatar,
    NDivider,
    NSpin,
    MessageSection,
  },
  data() {
    return {
      message: null,
      prevMessage: null,
    };
  },
  mounted() {
    this.setUpInterSectionObserver();
    this.draftAndSentMessagesStore.loadSentMessages();
  },
  beforeUnmount() {
    this.sentMessages = [];
    this.message = this.prevMessage = null;
    this.draftAndSentMessagesStore.sentMessages = [];
    this.draftAndSentMessagesStore.currentPage = 1;
    this.draftAndSentMessagesStore.maxPages = null;
  },
  setup() {
    const draftAndSentMessagesStore = useDraftAndSentMessagesStore();
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const { sentMessages } = storeToRefs(draftAndSentMessagesStore);
    const { currentPage } = storeToRefs(draftAndSentMessagesStore);
    const { maxPages } = storeToRefs(draftAndSentMessagesStore);
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    return {
      profiles,
      channels,
      sentMessages,
      draftAndSentMessagesStore,
      maxPages,
      currentPage,
    };
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.message;
      this.message = message;
    },
    handleClick(message) {
      switch (message.conversationable_type) {
        case 'BenchChannel':
          this.$router.push(`/channels/${message.conversationable_id}`);
          break;
        case 'Profile':
          this.$router.push(`/profiles/${message.conversationable_id}`);
          break;
        case 'Group':
          this.$router.push(`/groups/${message.conversationable_id}`);
          break;
        default:
          break;
      }
    },
    getImageSrc(message) {
      const receiver = this.profiles.find(
        profile => profile.id === message.receiver_id
      );
      return receiver?.image_url;
    },
    getIcon(message) {
      const channelDetail = this.channels.find(
        channel => channel.id === message.conversationable_id
      );
      return `fa-${channelDetail.is_private ? 'lock' : 'hashtag'}`;
    },
    setUpInterSectionObserver() {
      let options = {
        root: this.$refs['body'],
        margin: '10px',
      };
      let listEndObserver = new IntersectionObserver(
        this.handleIntersection,
        options
      );
      listEndObserver.observe(this.$refs['sentinel']);
    },
    handleIntersection([entry]) {
      if (entry.isIntersecting) {
        this.recordScrollPosition();
        if (this.sentMessages.length > 0) {
          this.draftAndSentMessagesStore.loadSentMessages();
        }
      }
    },
    recordScrollPosition() {
      let node = this.$refs['body'];
      this.previousScrollHeightMinusScrollTop =
        node.scrollHeight - node.scrollTop;
    },
  },
  computed: {
    isToday() {
      return (
        new Date(this.message.created_at).toDateString() ===
        new Date().toDateString()
      );
    },
    time() {
      return moment(new Date(this.message.created_at).getTime()).format(
        'h:mm A'
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.message?.created_at).toDateString() ===
        new Date(this.prevMessage?.created_at).toDateString()
      );
    },
    messageBlocks() {
      return JSON.parse(this.message.content).blocks;
    },
    isLastPage() {
      return this.maxPages === this.currentPage - 1;
    },
    isFirstMessage() {
      return this.sentMessages && this.sentMessages[0].id === this.message.id;
    },
  },
};
</script>

<style scoped>
.scrollable {
  overflow-y: scroll;
  height: 85vh;
}
</style>
