<template>
  <div v-if="chat.id">
    <div class="loading" v-show="loading">
      <Spinner />
    </div>
    <div class="header">
      <div class="headerContainer">
        <n-avatar class="avatar" size="small" :src="chat.avatar" />
        <span v-if="chat.isOnline" class="avatar__badge" />
        <p class="name">{{ chat.name }}</p>
        <n-icon size="25">
          <svg viewBox="0 0 24 24">
            <g>
              <path
                d="M10.55 2.532a2.25 2.25 0 0 1 2.9 0l6.75 5.692c.507.428.8 1.057.8 1.72v2.106a3.499 3.499 0 0 0-1.5-.905v-1.2a.75.75 0 0 0-.267-.574l-6.75-5.692a.75.75 0 0 0-.966 0L4.767 9.37a.75.75 0 0 0-.267.573v9.803c0 .138.112.25.25.25h3.5a.25.25 0 0 0 .25-.25v-5.5c0-.966.784-1.75 1.75-1.75h3.5l.102.003h1.775a3.482 3.482 0 0 0-.592 1.5H13v-.003h-2.75a.25.25 0 0 0-.25.25v5.5a1.75 1.75 0 0 1-1.75 1.75h-3.5A1.75 1.75 0 0 1 3 19.747V9.944c0-.663.293-1.292.8-1.72l6.75-5.692zM21 14.5a2.5 2.5 0 1 1-5 0a2.5 2.5 0 0 1 5 0zm2 5.375C23 21.431 21.714 23 18.5 23S14 21.437 14 19.875v-.103c0-.98.794-1.772 1.773-1.772h5.454c.98"
                fill="black"
              ></path>
            </g>
          </svg>
        </n-icon>
        <n-icon size="20">
          <svg viewBox="0 0 20 20">
            <g>
              <path
                d="M15.854 7.646a.5.5 0 0 1 .001.707l-5.465 5.484a.55.55 0 0 1-.78 0L4.147 8.353a.5.5 0 1 1 .708-.706L10 12.812l5.147-5.165a.5.5 0 0 1 .707-.001z"
                fill="black"
              ></path>
            </g>
          </svg>
        </n-icon>
      </div>
      <div class="phone-btn">
        <n-icon size="25">
          <svg viewBox="0 0 16 16">
            <g>
              <path
                d="M3.714 5.258C3.523 4 4.41 2.87 5.765 2.456a.988.988 0 0 1 1.214.598l.435 1.16a1 1 0 0 1-.26 1.088L5.86 6.487a.501.501 0 0 0-.152.47l.012.052l.031.13a7.265 7.265 0 0 0 .729 1.805a7.264 7.264 0 0 0 1.296 1.627l.04.036a.5.5 0 0 0 .482.103l1.673-.527a1 1 0 0 1 1.072.319l.792.961c.33.4.29.988-.089 1.341c-1.037.967-2.463 1.165-3.455.368a12.732 12.732 0 0 1-3.024-3.529a12.432 12.432 0 0 1-1.554-4.385zm3.043 1.765l1.072-.984a2 2 0 0 0 .521-2.176l-.434-1.16A1.988 1.988 0 0 0 5.473 1.5c-1.683.515-3.034 2.024-2.748 3.909c.2 1.316.661 2.99 1.678 4.738a13.732 13.732 0 0 0 3.262 3.805c1.488 1.195 3.474.787 4.764-.415c.766-.714.844-1.9.179-2.708l-.792-.962a2 2 0 0 0-2.144-.636l-1.389.437a6.604 6.604 0 0 1-.936-1.223a6.268 6.268 0 0 1-.59-1.421z"
                fill="black"
              ></path>
            </g>
          </svg>
        </n-icon>
      </div>
    </div>
  </div>
  <div class="header">
    <div class="headerContainer">
      <BookmarkPopUpVue @clicked="onClickChild"> </BookmarkPopUpVue>
      <p class="bookmarkText" v-for="bm in bookmarks" :key="bm.name">
        <BookmarkShowVue :data="bm" @clicked="onClickChild"> </BookmarkShowVue>
      </p>
    </div>
  </div>
</template>

<script>
import { NAvatar, NIcon, NSpace, NSpin } from 'naive-ui';
import BookmarkPopUpVue from './bookmark/popup.vue';
import BookmarkShowVue from './bookmark/bookmarkShow.vue';
import Spinner from '../../shared/spinner.vue';
import axios from './bookmark/axios/index.js';
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
  props: ['chat'],
  data() {
    return {
      bookmarks: [],
      loading: true,
      user_id: 1,
    };
  },
  mounted() {
    axios
      .get('bookmarks')
      .then(response => {
        this.bookmarks = response.data.bookmarks;
        console.log(this.bookmarks[0]);
        this.loading = false;
      })
      .catch(error => {
        this.loading = false;
        return error;
      });
  },
  methods: {
    onClickChild(value) {
      this.loading = true;
      this.bookmarks.push({ name: value.name, url: value.url });
      axios
        .post('bookmarks', {
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
<style scoped>
.header {
  align-items: center;
  border-bottom: 0.5px solid gray;
  display: flex;
  height: fit-content;
  justify-content: space-between;
  padding: 5px;
}
.headerContainer {
  display: flex;
  overflow-x: scroll;
  overflow-y: hidden;
  text-overflow: ellipsis;
  scrollbar-color: dark;
  padding: 5px;
}
.bookmarkText {
  color: rgb(99, 98, 98);
  font-size: small;
  margin: 0px;
}
.headerContainer:hover {
  border-radius: 3px;
  cursor: pointer;
}
.phone-btn {
  align-items: center;
  border-radius: 3px;
  display: flex;
  height: 30px;
  justify-content: center;
  margin: 0px 10px 0px 10px;
  width: 30px;
}
.phone-btn:hover {
  background-color: rgb(230, 232, 234);
  cursor: pointer;
}
.avatar {
  margin-right: 5px;
  width: fit-content;
}
.avatar__badge {
  background-color: rgb(54, 151, 54);
  border-radius: 50%;
  border: 2px solid white;
  height: 12px;
  margin-left: -12px;
  margin-top: 20px;
  position: relative;
  width: 12px;
}
.name {
  color: rgb(52, 51, 51);
  font-size: 20px;
  font-weight: 600;
  margin: 0 5px 0 0;
}
.loading {
  width: 80%;
  height: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
}
.loading > img {
  width: 50px;
  height: 50px;
}
</style>
