import { defineStore } from 'pinia';

export const useUserStore = () => {
  const userStore = defineStore('userStore', {
    state: () => ({
      users: [],
    }),

    getters: {
      getUsers: state => state.users,
    },

    actions: {
      async index() {
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
      async show(id) {
        return this.axios.get(`/user/${id}`).then(response => {
          this.user = response.data.user;
        });
      },
    },
  });
  const store = userStore();
  if (!store.users) {
    store.index();
  }

  return store;
};

// IT WILL BE USED IN FUTURE

// export const useUserStore = defineStore('userStore', {
//   state: () => ({
//     users: []
//   }),

//   getters: {
//     getUsers: (state) => state.users
//   },

//   actions: {
//     async index() {
//       const workSpaceId = 1;

//       return this.axios
//         .get(`workspaces/${workSpaceId}/profiles`)
//         .then(response => {
//           this.users = [...response.data.profiles];
//         })
//         .catch(error => {
//           return error;
//         });
//     },
//     async show(id) {
//       return this.axios.get(`/user/${id}`).then(response => {
//         this.user = response.data.user;
//       })
//     }
//   },
// })
