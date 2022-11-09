import { defineStore } from 'pinia'

export const SampleStore = defineStore('users', {
  state: () => {
    return {
      user: {},
      users: []
    }
  },

  actions: {
    async index() {
      return this.axios.get('/users').then(response => {
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
