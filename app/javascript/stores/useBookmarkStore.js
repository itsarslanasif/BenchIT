import { defineStore } from 'pinia';
import { getBookmarks } from '../api/bookmark/bookmark.js';
import { createBookmark } from '../api/bookmark/bookmark.js';
import { updateBookmark } from '../api/bookmark/bookmark.js';
import { deleteBookmark } from '../api/bookmark/bookmark.js';

export const useBookmarkStore = defineStore('useBookmarkStore', {
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
      return selectedType;
    },
    findAndReplace(id, updatedbookmark) {
      const index = this.bookmarks.findIndex(el => el.id === id);
      this.bookmarks[index] = updatedbookmark;
    },
    removeBookmark(bookmark_id) {
      this.bookmarks = this.bookmarks.filter(
        bookmark => bookmark.id !== bookmark_id
      );
    },

    async getbookmarks(bookmarkable_type, bookmarkable_id) {
      this.bookmarks = await getBookmarks(
        this.setbookmarkable_type(bookmarkable_type),
        bookmarkable_id
      );
    },

    async create_bookmark(
      name,
      bookmark_URL,
      bookmarkable_type,
      bookmarkable_id
    ) {
      let newBookmark = await createBookmark(
        name,
        bookmark_URL,
        this.setbookmarkable_type(bookmarkable_type),
        bookmarkable_id
      );
      this.bookmarks.push(newBookmark.data);
    },

    async update_bookmark(bookmark_id, name, bookmark_URL) {
      await updateBookmark(bookmark_id, name, bookmark_URL).then(response => {
        console.log(response);
        this.findAndReplace(response.data.bookmark.id, response.data.bookmark);
        return response.data.message;
      });
    },

    async delete_bookmark(bookmark_Id) {
      await deleteBookmark(bookmark_Id).then(response => {
        console.log(response);
        this.removeBookmark(bookmark_Id);
        return response.data.message;
      });
    },
  },
});
