import { defineStore } from 'pinia';

export const useSelectedScreenStore = defineStore('selectedScreenStore', {
  state: () => ({
    selectScreen: 'chat'
  }),

  getters: {
    getSelectedScreen: state => state.selectScreen,
  },

  actions: {
    setSelectedScreen(screen) {
      this.selectScreen = screen;
    },
    isChatScreen(){
        return this.selectScreen == 'chat'
    },
    isSearchDmScreen(){
        return this.selectScreen == 'search-dm'
    },
  },
});
