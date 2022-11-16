import { defineStore } from 'pinia'

export const UserStore = defineStore('userStore', {
  state: () => ({
    users: []
  }),

  getters: {
    getUsers: (state) => state.users
  },

  actions: {
    async index() {
      return this.axios
        .get('workspaces/3/profiles')
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
      })
    }
  },
})
