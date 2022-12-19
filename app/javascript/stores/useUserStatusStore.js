import { defineStore } from 'pinia'

const useUserStatusStore = defineStore('useUserStatusStore', {
  state: () => {
    return {
      active: false,
    }
  },
  getters: {
    status: state => state.status
  }
})

export default useUserStatusStore
