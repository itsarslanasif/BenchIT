import { defineStore } from 'pinia';

export const useProfileStore = () => {
  const userStore = defineStore('userStore', {
    state: () => ({
      users: [],
    }),

    getters: {
      getUsers: state => state.users,
    },

    actions: {
      index() {
        const workSpaceId = 1;

        return this.axios
          .get(`workspaces/${workSpaceId}/profiles`)
          .then(response => {
            this.users = [...response.data.profiles];
          })
          .catch(error => {
            return error;
          });
      },
    },
  });
  const store = userStore();
  if (!store.users.length) {
    store.index();
  }

  return store;
};
