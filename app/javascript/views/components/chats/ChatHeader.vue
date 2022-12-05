<template>
  <div v-if="chat.id" class="p-1">
    <div class="fixed h-1/2 w-3/4 items-center justify-items-center flex" v-show="loading">
      <Spinner />
    </div>
    <div class="items-center flex h-fit justify-between border-b border-primary">
      <div class="flex overflow-y-hidden text-ellipsis p-1">
        <n-avatar class="mr-1" size="small" :src="chat.avatar" />
        <span v-if="chat.isOnline" class="relative w-3 mt-5 h-3 -ml-3 border bg-success rounded-2xl border-success" />
        <p class="mr-1 text-lg font-semibold text-primary">{{ chat.name }}</p>
        <n-icon size="25">
          <svg viewBox="0 0 24 24">
            <g>
              <path
                d="M10.55 2.532a2.25 2.25 0 0 1 2.9 0l6.75 5.692c.507.428.8 1.057.8 1.72v2.106a3.499 3.499 0 0 0-1.5-.905v-1.2a.75.75 0 0 0-.267-.574l-6.75-5.692a.75.75 0 0 0-.966 0L4.767 9.37a.75.75 0 0 0-.267.573v9.803c0 .138.112.25.25.25h3.5a.25.25 0 0 0 .25-.25v-5.5c0-.966.784-1.75 1.75-1.75h3.5l.102.003h1.775a3.482 3.482 0 0 0-.592 1.5H13v-.003h-2.75a.25.25 0 0 0-.25.25v5.5a1.75 1.75 0 0 1-1.75 1.75h-3.5A1.75 1.75 0 0 1 3 19.747V9.944c0-.663.293-1.292.8-1.72l6.75-5.692zM21 14.5a2.5 2.5 0 1 1-5 0a2.5 2.5 0 0 1 5 0zm2 5.375C23 21.431 21.714 23 18.5 23S14 21.437 14 19.875v-.103c0-.98.794-1.772 1.773-1.772h5.454c.98"
                fill="black"></path>
            </g>
          </svg>
        </n-icon>
        <n-icon size="20">
          <svg viewBox="0 0 20 20">
            <g>
              <path
                d="M15.854 7.646a.5.5 0 0 1 .001.707l-5.465 5.484a.55.55 0 0 1-.78 0L4.147 8.353a.5.5 0 1 1 .708-.706L10 12.812l5.147-5.165a.5.5 0 0 1 .707-.001z"
                fill="black"></path>
            </g>
          </svg>
        </n-icon>
      </div>
      <div class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-slate-100 cursor-pointer">
        <n-icon size="25">
          <svg viewBox="0 0 16 16">
            <g>
              <path
                d="M3.714 5.258C3.523 4 4.41 2.87 5.765 2.456a.988.988 0 0 1 1.214.598l.435 1.16a1 1 0 0 1-.26 1.088L5.86 6.487a.501.501 0 0 0-.152.47l.012.052l.031.13a7.265 7.265 0 0 0 .729 1.805a7.264 7.264 0 0 0 1.296 1.627l.04.036a.5.5 0 0 0 .482.103l1.673-.527a1 1 0 0 1 1.072.319l.792.961c.33.4.29.988-.089 1.341c-1.037.967-2.463 1.165-3.455.368a12.732 12.732 0 0 1-3.024-3.529a12.432 12.432 0 0 1-1.554-4.385zm3.043 1.765l1.072-.984a2 2 0 0 0 .521-2.176l-.434-1.16A1.988 1.988 0 0 0 5.473 1.5c-1.683.515-3.034 2.024-2.748 3.909c.2 1.316.661 2.99 1.678 4.738a13.732 13.732 0 0 0 3.262 3.805c1.488 1.195 3.474.787 4.764-.415c.766-.714.844-1.9.179-2.708l-.792-.962a2 2 0 0 0-2.144-.636l-1.389.437a6.604 6.604 0 0 1-.936-1.223a6.268 6.268 0 0 1-.59-1.421z"
                fill="black"></path>
            </g>
          </svg>
        </n-icon>
      </div>
    </div>
  </div>
  <div class="flex items-center h-fit justify-between p-1 border-b border-primary">
    <div class="flex overflow-y-hidden text-ellipsis p-1 cursor-pointer">
      <BookmarkPopUpVue @clicked="onClickChild"> </BookmarkPopUpVue>
      <p class="bookmarkText" v-for="bookmark in bookmarks" :key="bm.name">
        <BookmarkShowVue :data="bookmark" @clicked="onClickChild"> </BookmarkShowVue>
      </p>
    </div>
  </div>
</template>

<script>
import { NAvatar, NIcon, NSpace, NSpin } from 'naive-ui';
import BookmarkPopUpVue from '../bookmark/popup.vue';
import BookmarkShowVue from '../bookmark/bookmarkShow.vue';
import Spinner from '../../shared/spinner.vue';
import axios from '../../../modules/axios/index';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';
export default {
  name: 'ChatHeader',
  components: {
    NAvatar,
    NIcon,
    BookmarkPopUpVue,
    BookmarkShowVue,
    NSpace,
    NSpin,
    Spinner,
  },
  data() {
    return {
      bookmarks: [],
      loading: true,
      user_id: 1,
      chat: {},
    };
  },
  mounted() {
    axios
      .get(`v1/bench_channels/${1}/bookmarks`)
      .then(response => {
        this.bookmarks = response.data.bookmarks;
        this.loading = false;
      })
      .catch(error => {
        this.loading = false;
        return error;
      });
  },
  watch: {
    messages(msg) {
      this.chat = {
        id: msg[0]?.bench_conversation_id,
        name: msg[0]?.channel_name
          ? msg[0]?.channel_name
          : msg[0]?.group_id
            ? 'Group Chat ' + msg[0]?.group_id
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
    return {
      messages,
    };
  },
  methods: {
    onClickChild(value) {
      this.loading = true;
      this.bookmarks.push({ name: value.name, url: value.url });
      axios
        .post(`v1/bench_channels/${1}/bookmarks`, {
          name: value.name,
          bookmark_URL: value.url,
          user_id: this.user_id,
        })
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
