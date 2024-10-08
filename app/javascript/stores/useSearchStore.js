import { defineStore } from 'pinia';
import { getSearching } from '../api/searchBar';
import { errorHandler } from '../views/widgets/messageProvider';

export const useSearchStore = () => {
  const searchStore = defineStore('useSearchStore', {
    state: () => ({
      searches: {},
      searched: '',
    }),

    getters: {
      getSearches: state => state.searches,
      getSearch: state => state.searched,
    },

    actions: {
      async index(query, filter = null) {
        try {
          this.searches = await getSearching(query, filter);
        } catch (e) {
          this.handleError(e.response.data.message);
        }
      },
      clearSearches() {
        if (!this.searched) {
          this.searches = {};
        }
      },
      setSearch(search) {
        this.searched = search;
      },
      handleError(error) {
        errorHandler(error.response.data.message);
      },
    },
  });

  return searchStore();
};
