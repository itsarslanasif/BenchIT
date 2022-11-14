<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">What's your email?</h3>
    <label>Email</label>
    <input
      v-model="userStore.user_email.email"
      type="email"
      placeholder="Email"
      required
      class="form-input-select"
    />
    <div class="btn-div">
      <button class="form-btn">Send Invitation</button>
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
      axios
        .post('users/invitation', this.userStore.user_email)
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
