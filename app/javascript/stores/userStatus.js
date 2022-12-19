import { defineStore } from 'pinia'

const userStatusStore = defineStore('userStatusStore', {
  state: () => {
    return {
      active: false,
    }
  },
  getters: {
    status: state => state.status
    }
  }
)

export default userStatusStore
