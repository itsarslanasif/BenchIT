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
    index() {
      return this.axios.get('/channels').then(response => {
        this.users = response.data.users;
      })
    },
  },
})
