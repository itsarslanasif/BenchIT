<template>
  <div v-if="newBookMark">
    <a
      @click="toggleBookmarkModel"
      class="border border-transparent text-xs px-2 py-1 mr-2 overflow-auto rounded-md text-black-600 hover:text-primary hover:bg-transparent w-max inline-block">
      <i class="fa-solid fa-add"></i>
      {{ $t('bookmark.add_bookmark') }}
    </a>
    <div v-if="modalOpen">
      <bookMarkModel
        title="Create BookMark"
        :newBookMark="newBookMark"
        :toggleModel="toggleBookmarkModel"
        :channelId="channelId"
      />
    </div>
  </div>
  <div v-if="!newBookMark">
    <a
      @click="toggleBookmarkModel"
      class="border border-transparent text-xs px-2 py-1 mr-2 overflow-auto rounded-md text-black-600 hover:text-primary hover:bg-transparent w-max inline-block"
      >{{ bookMarkObject.name }}</a
    >
    <div v-if="modalOpen">
      <bookMarkModel
        title="Update or Delete BookMark"
        :newBookMark="newBookMark"
        :toggleModel="toggleBookmarkModel"
        :bookMarkObject="bookMarkObject"
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
      bookmark: {
        bookMarkLink: 'asad',
        bookMarkTitle: 'asad',
      },
      modalOpen: false,
    };
  },
  methods: {
    toggleBookmarkModel() {
      this.modalOpen = !this.modalOpen;
    },
  },
};
</script>
