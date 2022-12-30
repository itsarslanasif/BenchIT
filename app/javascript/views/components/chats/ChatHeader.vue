<template>
  <div class="loading" v-if="loading">
    <Spinner />
  </div>
  <div v-if="chat && conversation_type === 'channels'">
    <ChannelInfo :channel="chat" />
  </div>
  <div v-if="chat && conversation_type === 'groups'">
    <ChannelInfo :channel="chat" />
  </div>
  <div v-else-if="chat && conversation_type === 'profiles'">
    <UserChatInfo :chat="chat" />
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
import PinnedConversationModelVue from '../pinnedConversation/pinnedConversationModel.vue';
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
    PinnedConversationModelVue,
    ChannelInfo,
    UserChatInfo,
  },
  data() {
    return {
      bookmarks: [],
      loading: true,
      user_id: 1,
      chat: {},
      conversation_type: window.location.pathname.split('/')[1],
    };
  },
  beforeUnmount() {
    this.bookmarks = this.chat = null;
  },
  mounted() {
    try {
      axios
        .get(`v1/bench_channels/${1}/bookmarks`, {
          headers: { Authorization: sessionStorage.getItem('token') },
        })
        .then(response => {
          this.bookmarks = response.data.bookmarks;
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
          return error;
        });
    } catch (e) {
      console.error(e);
    }
  },
  watch: {
    messages(msg) {
      this.chat = {
        id: window.location.pathname.split('/')[2],
        name: msg[0]?.channel_name
          ? msg[0]?.channel_name
          : msg[0]?.group_name
          ? msg[0]?.group_name
          : msg[0]?.receiver_name,
        isActive: true,
        status: '',
        avatar:
          'data:image/png;base64,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',
      };
    },
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
  methods: {
    onClickChild(value) {
      this.loading = true;
      this.bookmarks.push({ name: value.name, url: value.url });
      try {
        axios
          .post(
            `v1/bench_channels/${1}/bookmarks`,
            {
              headers: { Authorization: sessionStorage.getItem('token') },
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
      } catch (e) {
        console.error(e);
      }
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
