import { defineStore } from 'pinia';
import { getBookmarks } from '../api/bookmark/bookmark.js';
import { createBookmark } from '../api/bookmark/bookmark.js';

export const useBookmarkStore = defineStore('BookmarkStore', {
  state: () => ({
    bookmarks: [],
  }),

  getters: {
    getBookmarks() {
      return this.Bookmarks;
    },
    getCount() {
      return this.Bookmarks.length;
    },
  },

  actions: {

    setbookmarkable_type(type) {
      let selectedType = '';
      switch (type) {
        case 'profiles':
          selectedType = 'Profile';
          break;
        case 'channels':
          selectedType = 'BenchChannel';
          break;
        case 'groups':
          selectedType = 'Group';
          break;
      }
      return selectedType
    },

    async getbookmarks(bookmarkable_type, bookmarkable_id) {

      this.bookmarks = await getBookmarks(this.setbookmarkable_type(bookmarkable_type), bookmarkable_id);
    },
    async create_bookmark(name, bookmark_URL, bookmarkable_type, bookmarkable_id) {
      let newBookmark=await createBookmark(name, bookmark_URL, this.setbookmarkable_type(bookmarkable_type), bookmarkable_id);
      this.bookmarks.push(newBookmark.data);
    },
  },
});
