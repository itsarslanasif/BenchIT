import { defineStore } from 'pinia'

export const useChannelStore = defineStore('channelStore', {
  state: () => ({
    channels: [
      {
        id: 1,
        name: 'bench-it'
      },
      {
        id: 2,
        name: 'general'
      },
      {
        id: 3,
        name: 'dev-general',
      },
      {
        id: 4,
        name: 'watercooler'
      }
    ]
  }),

  getters: {
    getChannels: (state) => state.channels
  },

  actions: {
    async index() {
      return this.axios.get('/channels').then(response => {
        this.users = response.data.users;
      })
    },
    async show(id) {
      return this.axios.get(`/channels/${id}`).then(response => {
        this.user = response.data.user;
      })
    }
  },
})
