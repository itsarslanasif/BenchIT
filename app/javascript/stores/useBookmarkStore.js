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
    async getbookmarks(id) {
      this.bookmarks = await getBookmarks(id);
    },
    async create_bookmark(channel_id,name,bookmark_URL,user_id) {
      let newBookmark=await createBookmark(channel_id,name,bookmark_URL,user_id);
      this.bookmarks.push(newBookmark.data);
    },
  },
});
