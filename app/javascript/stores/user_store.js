import { defineStore } from 'pinia'

export const UserStore = defineStore('user', {
  state: () => {
    return {
      user_email: {
        email: '',
      },
      user_password: {
        password: '',
        password_confirmation: '',
        invitation_token: '',
      },
      confirmPasswordError: '',
    }
  }
})
