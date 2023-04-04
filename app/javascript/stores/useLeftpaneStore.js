import { defineStore } from 'pinia';

export const useLeftpaneStore = () => {
  const leftpaneStore = defineStore('leftpaneStore', {
    state: () => ({
      leftPaneFlag: true,
    }),
    getters: {
      getLeftpaneFlag: state => state.leftPaneFlag,
    },
    actions: {
      closeLeftPane() {
        this.leftPaneFlag = false;
      },
      openLeftPane() {
        this.leftPaneFlag = true;
      },
    },
  });

  return leftpaneStore();
};
