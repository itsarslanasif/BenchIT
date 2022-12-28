<template>
  <div v-if="newBookMark">
    <a
      @click="toggleBookmarkModel"
      class="border border-transparent text-xs px-2 py-1 mr-2 overflow-auto rounded-md text-black-600 hover:text-primary hover:bg-transparent w-max inline-block"
    >
      <i class="fa-solid fa-add"></i>
      {{ $t('bookmark.add_bookmark') }}
    </a>
    <div v-if="modalOpen">
      <bookMarkModel
        title="Create Bookmark"
        :newBookMark="newBookMark"
        :toggleModel="toggleBookmarkModel"
        :channelId="channelId"
        :bookmarkable_type="bookmarkable_type"
        :bookmarkable_id="bookmarkable_id"
      />
    </div>
  </div>
  <div v-if="!newBookMark" oncontextmenu="return false;">
    <span
      @click.right="toggleBookmarkModel"
      @click="openLink"
      class="border border-transparent text-xs px-2 py-1 mr-2 overflow-auto rounded-md text-black-600 hover:text-primary hover:bg-transparent w-max inline-block"
      >{{ bookMarkObject.name }}</span
    >
    <div v-if="modalOpen">
      <bookMarkModel
        title="Update or delete Bookmark"
        :newBookMark="newBookMark"
        :toggleModel="toggleBookmarkModel"
        :bookMarkObject="bookMarkObject"
        :bookmarkable_type="bookmarkable_type"
        :bookmarkable_id="bookmarkable_id"
      />
    </div>
  </div>
</template>

<script>
import bookMarkModel from '../bookmark/bookMarkModel.vue';
export default {
  props: ['bookMarkObject', 'newBookMark', 'channelId'],
  components: {
    bookMarkModel,
  },
  data() {
    return {
      bookmarkable_type: window.location.pathname.split('/')[1],
      bookmarkable_id: window.location.pathname.split('/')[2],
      modalOpen: false,
    };
  },
  methods: {
    toggleBookmarkModel() {
      this.modalOpen = !this.modalOpen;
    },
    openLink() {
      window.open('https://' + this.bookMarkObject.bookmark_URL);
    },
  },
};
</script>
