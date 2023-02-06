import { defineStore } from 'pinia';
import { getSearching } from '../api/searchBar';

export const useSearchStore = () => {
  const searchStore = defineStore('useSearchStore', {
    state: () => ({
      searches: {},
      searched: ''
    }),

    getters: {
      getSearches: state => state.searches,
      getSearch: state => state.searched
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
        if (!this.searched){
          this.searches = {}
        }
      },
      setSearch(search) {
        this.searched = search
      }
    },
  });
  
  return searchStore();
};
