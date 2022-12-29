import { defineStore } from 'pinia'

export const useUserInviteStore = defineStore('user', {
  state: () => {
    return {
      user_email: {
        email: null,
      },
      user_password: {
        password: null,
        password_confirmation: null,
        invitation_token: null,
      },
      workspace_invite: {
        email: null,
      },
      confirmPasswordError: null,
    }
  }
})
