import { defineStore } from 'pinia'

export const UserStore = defineStore('userStore', {
  state: () => ({
    users: [
      {
        id: 1,
        name: 'John Doe'
      },
      {
        id: 2,
        name: 'Jane'
      },
      {
        id: 3,
        name: 'Daniel'
      },
      {
        id: 4,
        name: 'Vicky'
      },
    ]
  }),

  getters: {
    getUsers: (state) => state.users
  },

  actions: {
    async index() {
      return this.axios.get('/user').then(response => {
        this.users = response.data.users;
      })
    },
    async show(id) {
      return this.axios.get(`/user/${id}`).then(response => {
        this.user = response.data.user;
      })
    }
  },
})
