<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">Set Your Password</h3>
    <h5 class="form-h">Create a password for signing in</h5>
    <label>Password</label>
    <input
      v-model="password"
      class="form-input-select"
      type="password"
      placeholder="Password"
      required
    />
    <div v-if="passwordError" class="error">{{ passwordError }}</div>
    <p class="form-h">Password must be at least 6 characters long</p>
    <label>Confirm Password</label>
    <input
      v-model="confirm_password"
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
export default {
  data() {
    return {
      confirm_password: '',
      confirmPasswordError: '',
      password: '',
      passwordError: '',
    };
  },
  methods: {
    handleSubmit() {
      this.passwordError =
        this.password.length > 6
          ? ''
          : 'Password must be at least 6 chars long';
      this.confirmPasswordError =
        this.password === this.confirm_password ? '' : 'Passwords do not match';
    },
  },
};
</script>
