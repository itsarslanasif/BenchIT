<template>
  <div class="loading" v-if="loading">
    <Spinner />
  </div>
  <div v-if="conversation_type === $t('conversations.channels')">
    <ChannelInfo />
  </div>
  <div v-if="conversation_type === $t('conversations.groups')">
    <ChannelInfo />
  </div>
  <div v-else-if="conversation_type === $t('conversations.profiles')">
    <UserChatInfo />
  </div>
  <div
    class="flex items-center h-8 justify-between px-1 mt-1 shadow-md custom-border"
  >
    <div
      class="flex overflow-y-hidden text-ellipsis items-center cursor-pointer"
    >
      <PinnedConversation />
    </div>
  </div>
</template>

<script>
import { NAvatar, NIcon, NSpace, NSpin } from 'naive-ui';
import BookmarkPopUp from '../bookmark/popup.vue';
import BookmarkShow from '../bookmark/bookmarkShow.vue';
import Spinner from '../../shared/spinner.vue';
import axios from '../../../modules/axios/index';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import PinnedConversation from '../pinnedConversation/pinnedConversation.vue';
import ChannelInfo from '../channels/ChannelInfo.vue';
import UserChatInfo from './UserChatInfo.vue';

export default {
  name: 'ChatHeader',
  components: {
    NAvatar,
    NIcon,
    BookmarkPopUp,
    BookmarkShow,
    NSpace,
    NSpin,
    Spinner,
    PinnedConversation,
    ChannelInfo,
    UserChatInfo,
  },
  data() {
    return {
      bookmarks: [],
      loading: true,
      user_id: 1,
      conversation_type: window.location.pathname.split('/')[1],
    };
  },
  mounted() {
    axios
      .get(`v1/bench_channels/${1}/bookmarks`, {
        headers: { Authorization: localStorage.getItem('token') },
      })
      .then(response => {
        this.bookmarks = response.data.bookmarks;
        this.loading = false;
      })
      .catch(error => {
        this.loading = false;
        return error;
      });
  },
  setup() {
    const messageStore = useMessageStore();
    const { messages } = storeToRefs(messageStore);
    const pinnedConversationStore = usePinnedConversation();

    return {
      messages,
      pinnedConversationStore,
    };
  },
  beforeUnmount() {
    this.pinnedConversationStore.closeModal();
  },
  methods: {
    onClickChild(value) {
      this.loading = true;
      this.bookmarks.push({ name: value.name, url: value.url });
      axios
        .post(
          `v1/bench_channels/${1}/bookmarks`,
          {
            headers: { Authorization: localStorage.getItem('token') },
          },
          {
            name: value.name,
            bookmark_URL: value.url,
            user_id: this.user_id,
          }
        )
        .then(response => {
          this.members = response.data.profiles;
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
          return error;
        });
    },
  },
};
</script>
<style scoped>
.bookmarkText {
  color: rgb(99, 98, 98);
  font-size: small;
}
.custom-border {
  border-bottom: 0.5px solid gray;
}
.loading {
  width: 80%;
  height: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
}
</style>
