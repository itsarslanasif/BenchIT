<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">{{ $t('confirmation.title') }}</h3>
    <label>{{ $t('confirmation.password') }}</label>
    <input
      v-model="userStore.user_password.password"
      class="form-input-select"
      type="password"
      placeholder="Password"
      required
    />
    <div v-if="userStore.passwordError" class="error">
      {{ userStore.passwordError }}
    </div>
    <p class="form-h">{{ $t('confirmation.description') }}</p>
    <label>{{ $t('confirmation.confirm_password') }}</label>
    <input
      v-model="userStore.user_password.password_confirmation"
      class="form-input-select"
      type="password"
      placeholder="Confirm Password"
      required
    />
    <div v-if="userStore.confirmPasswordError" class="error">
      {{ userStore.confirmPasswordError }}
    </div>
    <div class="btn-div">
      <button class="form-btn">{{ $t('confirmation.password_save') }}</button>
    </div>
  </form>
</template>

<script>
import axios from '../axios';
import { UserStore } from '../../stores/user_store.js';
import '../workspace/style.css';

export default {
  data() {
    return {
      userStore: UserStore(),
    };
  },
  methods: {
    handleSubmit() {
      if (
        this.userStore.user_password.password ===
        this.userStore.user_password.password_confirmation
      ) {
        (this.userStore.confirmPasswordError = ''),
          (this.userStore.user_password.invitation_token =
            this.$route.query.invitation_token),
          axios
            .patch('users/invitation', this.userStore.user_password)
            .then(response => {
              return response.data;
            })
            .catch(error => {
              return error;
            });
        this.$router.push('/workspace_dashboard');
      } else {
        this.userStore.confirmPasswordError = 'Passwords do not match';
      }
    },
  },
};
</script>
