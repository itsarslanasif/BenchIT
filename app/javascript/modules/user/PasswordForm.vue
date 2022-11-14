<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">Set Your Password</h3>
    <h5 class="form-h">Create a password for signing in</h5>
    <label>Password</label>
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
    <p class="form-h">Password must be at least 6 characters long</p>
    <label>Confirm Password</label>
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
      <button class="form-btn">Save</button>
    </div>
  </form>
</template>

<script>
import '../workspace/style.css';
import axios from '../workspace/axios';
import { UserStore } from '../../stores/user_store.js';
export default {
  data() {
    return {
      userStore: UserStore(),
    };
  },
  methods: {
    handleSubmit() {
    if (this.userStore.user_password.password === this.userStore.user_password.password_confirmation) {
      this.userStore.confirmPasswordError = '',
      this.userStore.user_password.invitation_token = this.$route.query.invitation_token,
      axios
        .patch('users/invitation', this.userStore.user_password)
        .then(response => {
          return response.data;
        })
        .catch(error => {
          return error;
        });
    } else {
      this.userStore.confirmPasswordError = 'Passwords do not match'
    }

    },
  },
};
</script>

