import { defineStore } from 'pinia';

export const useErrorStore = () => {
  const errorStore = defineStore('errorStore', {  state: () => ({
     errorFlag: false,
     error: {}
  }),
  getters: {
    getError: state => state.error
  },
  actions: {
    async showError(err) {
     this.errorFlag = true
     this.error = err
    },
    async toggleErrorFlag() {
      this.errorFlag = false
      this.error = {}
      console.log('hi')
    }
  },
})
const store = errorStore();
return store;
}
