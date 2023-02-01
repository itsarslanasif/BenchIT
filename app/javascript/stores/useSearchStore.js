import { defineStore } from 'pinia';
import { getSearching } from '../api/searchBar';

export const useSearchStore = () => {
  const searchStore = defineStore('useSearchStore', {
    state: () => ({
      searches: {}
    }),

    getters: {
      getSearches: state => state.searches,
    },

    actions: {
      async index(query, filter = null) {
        try {
          this.searches = await getSearching(query, filter);
        } catch (e) {
          console.error(e);
        }
      },
      clearSearches() {
        this.searches = {}
      }
    },
  });
  const store = searchStore();

  return store;
};
