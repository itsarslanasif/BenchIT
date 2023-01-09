import { defineStore } from 'pinia'

export const useStarredChannelsStore = defineStore('starredchannels', {
  state: () => {
    return {
      starChannels: [],
    }
  },
  actions: {
    addStarredChannel(channel) {
      this.starChannels.push(channel);
    },
    removeStarredChannel(channel) {
      const index = this.starChannels.indexOf(channel);
      if (index > -1) {
        this.starChannels.splice(channel, 1);
      }
    }
  }
})
