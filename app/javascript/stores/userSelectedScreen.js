import {
  defineStore
} from 'pinia';

export const useSelectedScreenStore = defineStore('selectedScreenStore', {
  state: () => ({
    selectScreen: 'chat'
  }),

  getters: {
    getSekectedScreen: state => state.selectScreen,
  },

  actions: {
    setSelectedScreen(screen) {
      this.selectScreen = screen;
    },
    isChatScreen(){
      if(this.selectScreen == 'chat'){
        return true
      }
    },
    isSearchDmScreen(){
      if(this.selectScreen == 'search-dm'){
        return true
      }
    },
  },
});
