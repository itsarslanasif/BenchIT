<template>
  <div v-if="draftMessages.length !== 0" class="scrollable bg-gray-100 mb-1">
    <div v-for="message in draftMessages" :key="message.id" ref="body">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
        <div v-if="isToday" class="text-xs text-black ml-10 font-bold m-4">
          <p>{{ $t('messages_section.today') }}</p>
        </div>
        <div v-else class="text-xs text-black ml-10 font-bold m-4">
          <p>{{ new Date(message.created_at).toDateString() }}</p>
        </div>
      </div>
      <div
        @click="handleClick(message)"
        class="ml-2 mr-2 bg-white border border-black-100 cursor-pointer flex p-4 hover:bg-gray-100"
      >
        <div class="min-w-fit ml-1">
          <div v-if="message.conversationable_type === 'Profile'">
            <img :src="getImageSrc(message)" class="w-10 rounded" />
          </div>
          <div
            class="bg-slate-100 w-10 h-10 rounded flex items-center justify-center text-base"
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
        <div class="ml-3 leading-3 flex justify-center flex-col">
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
            {{ $t('heading.thread_in_group') + message.group_id }}
          </div>
          <div
            v-else-if="
              !message.is_threaded &&
              message.conversationable_type === $t('conversation.group')
            "
            class="font-semibold"
          >
            {{ $t('heading.message_in_group') + message.group_id }}
          </div>
          <br />
          <span v-for="block in messageBlocks" :key="block">
            <MessageSection v-if="block.type === 'section'" :section="block" />
          </span>
        </div>
        <div class="margin-left text-black-600">
          {{ time }}
        </div>
      </div>
    </div>
  </div>
  <div v-else class="flex flex-col justify-center items-center mt-10">
    <font-awesome-icon icon="fa-solid fa-pencil" class="text-2xl mb-2" />
    <p class="font-bold text-base text-center w-100">
      {{ $t('drafts.title') }}
    </p>
    <p class="text-base text-center w-100">
      {{ $t('drafts.description') }}
    </p>
  </div>
  <div ref="sentinel"></div>
  <div class="flex items-center justify-center">
    <n-spin
      v-if="draftMessages.length !== 0 && !isLastPage"
      class="self-center my-2"
      size="small"
    />
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
    this.draftAndSentMessagesStore.loadDraftMessages();
  },
  beforeUnmount() {
    this.draftMessages = [];
    this.message = this.prevMessage = null;
    this.draftAndSentMessagesStore.currentPage = 1;
  },
  setup() {
    const draftAndSentMessagesStore = useDraftAndSentMessagesStore();
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const { draftMessages, maxPages, currentPage } = storeToRefs(
      draftAndSentMessagesStore
    );
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    return {
      profiles,
      channels,
      draftMessages,
      maxPages,
      currentPage,
      draftAndSentMessagesStore,
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
        this.draftAndSentMessagesStore.loadDraftMessages();
      }
    },
    recordScrollPosition() {
      let node = this.$refs['body'];
      this.previousScrollHeightMinusScrollTop =
        node.scrollHeight - node.scrollTop;
    },
    restoreScrollPosition() {
      if (!this.firstMount) {
        let node = this.$refs['body'];
        node.scrollTop =
          node.scrollHeight - this.previousScrollHeightMinusScrollTop;
      }
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
  },
};
</script>
<style scoped>
.scrollable {
  overflow-y: scroll;
  height: 85vh;
}
.margin-left {
  margin-left: auto;
}
</style>
