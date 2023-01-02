import { defineStore } from 'pinia';

export const useCurrentUserStore = () => {
  const currentUserStore = defineStore('currentUserStore', {
    state: () => ({
      currentUser: {},
    }),

    getters: {
      getCurrentUser: state => state.currentUser,
    },

    actions: {
      setUser(user) {
        this.currentUser = user;
      },
    },
  });
  const store = currentUserStore();

  return store;
};
