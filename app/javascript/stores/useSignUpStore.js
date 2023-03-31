import { defineStore } from 'pinia';
import { userSignUp } from '../api/user_auth/user_sign_up_api';
import { errorHandler } from '../views/widgets/messageProvider';

export const useSignUpStore = defineStore('signUpStore', {
  state: () => ({
    email: '',
    isformSubmitted: false,
  }),

  getters: {
    getEmail: state => state.message,
  },

  actions: {
    async signUpUser(name, email, password) {
      try {
        await userSignUp({ name, email, password });
        this.email = email;
        this.isformSubmitted = true;
      } catch (e) {
        errorHandler(error.response.data.message);
      }
    },
  },
});
