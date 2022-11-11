<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">Set Your Password</h3>
    <h5 class="form-h">Create a password for signing in</h5>
    <label>Password</label>
    <input
      v-model="user.password"
      class="form-input-select"
      type="password"
      placeholder="Password"
      required
    />
    <div v-if="passwordError" class="error">{{ passwordError }}</div>
    <p class="form-h">Password must be at least 6 characters long</p>
    <label>Confirm Password</label>
    <input
      v-model="user.password_confirmation"
      class="form-input-select"
      type="password"
      placeholder="Confirm Password"
      required
    />
    <div v-if="confirmPasswordError" class="error">
      {{ confirmPasswordError }}
    </div>
    <div class="btn-div">
      <button class="form-btn">Save</button>
    </div>
  </form>
</template>

<script>
import './style.css';
import axios from './axios';
export default {
  data() {
    return {
      passwordError: '',
      confirmPasswordError: '',
      user: {
      password: '',
      password_confirmation: '',
      }
    };
  },
  methods: {
    handleSubmit() {
      // this.passwordError =
      //   this.password.length > 6
      //     ? ''
      //     : 'Password must be at least 6 chars long';
      // this.confirmPasswordError =
      //   this.password === this.confirm_password ? '' : 'Passwords do not match';
      axios
        .put('users/invitation', this.user)
        .then(response => {
          return response.data;
        })
        .catch(error => {
          return error;
        });
    },
  },
};
</script>

